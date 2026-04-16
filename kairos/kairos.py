#!/usr/bin/env python3
"""KAIROS — OctoPulse autonomous tick loop daemon."""
import argparse, asyncio, json, os, re, signal, sys, time
from dataclasses import dataclass
from datetime import date, datetime, timezone
from pathlib import Path
from typing import Any, Optional

# Local modules
import yaml
from claude_runner import ClaudeRunner, RunResult
from telegram_notifier import TelegramNotifier
from scheduler import Scheduler, Job
from calendar_engine import load_engine_from_config, Alert, CalendarEngine
from reactive import load_watcher_from_config, Trigger, ReactiveWatcher

LOG_FILE = "daemon.jsonl"

MARKDOWN_STRIP = str.maketrans({c: "" for c in "_*`[]()~>#+=|{}!"})


def _safe_excerpt(s: str, maxlen: int = 300) -> str:
    s = (s or "").translate(MARKDOWN_STRIP)
    if len(s) > maxlen:
        s = s[:maxlen] + "…"
    return s


@dataclass
class SyntheticJob:
    """Uniform shape for scheduled jobs + calendar alerts + reactive triggers."""
    id: str
    agent: Optional[str]
    prompt: str
    priority: str
    notify_on: list[str]
    source: str                   # "scheduled" | "calendar" | "reactive"
    source_ref: Any = None        # Job / Alert / Trigger

class Kairos:
    def __init__(self, config_path: str, dry_run: bool = False):
        self.config_path = os.path.expanduser(config_path)
        with open(self.config_path) as f:
            self.cfg = yaml.safe_load(f) or {}
        self.dry_run = dry_run
        kcfg = self.cfg.get("kairos", {})
        self.tick_interval = int(kcfg.get("tick_interval_sec", 60))
        self.log_dir = Path(os.path.expanduser(kcfg.get("log_dir", "~/logs/kairos")))
        self.log_dir.mkdir(parents=True, exist_ok=True)
        self.heartbeat_path = Path(os.path.expanduser(
            kcfg.get("heartbeat_path", "~/octopulse/kairos/heartbeat")))
        self.marty_chat_id = str(kcfg.get("telegram_chat_id", ""))
        self.reports_dir = Path(os.path.expanduser(
            "~/octopulse/team-workspace/marketing/reports/kairos"))
        self.reports_dir.mkdir(parents=True, exist_ok=True)

        ccfg = self.cfg.get("claude", {})
        self.claude = ClaudeRunner(
            binary=ccfg.get("binary", "claude"),
            flags=ccfg.get("flags", ["--dangerously-skip-permissions"]),
            working_dir=ccfg.get("working_dir", "~/octopulse"),
            timeout_sec=int(ccfg.get("timeout_sec", 900)),
            max_concurrent=int(kcfg.get("max_concurrent_claude", 3)),
            log_dir=str(self.log_dir),
            retry_count=int(ccfg.get("retry_count", 1)),
            retry_backoff_sec=int(ccfg.get("retry_backoff_sec", 30)),
        )
        self.telegram = TelegramNotifier(log_dir=str(self.log_dir), dry_run=dry_run)
        self.scheduler = Scheduler(self.config_path)
        self.calendar: Optional[CalendarEngine] = load_engine_from_config(self.config_path)
        self.reactive: ReactiveWatcher = load_watcher_from_config(self.config_path)

        self._shutdown = asyncio.Event()
        self._inflight: set[asyncio.Task] = set()

        # F10: umask=0077 enforces 0600 via systemd; also chmod existing log files defensively
        for log_file in ("daemon.jsonl", "telegram.jsonl"):
            p = self.log_dir / log_file
            if p.exists():
                os.chmod(p, 0o600)

        # F8: recover any inflight triggers that were interrupted on last run
        self.reactive.recover_inflight()

    def _log(self, event: str, **payload) -> None:
        record = {
            "ts": datetime.now(timezone.utc).isoformat(),
            "event": event, **payload,
        }
        with (self.log_dir / LOG_FILE).open("a") as f:
            f.write(json.dumps(record, ensure_ascii=False) + "\n")

    def _heartbeat(self) -> None:
        self.heartbeat_path.parent.mkdir(parents=True, exist_ok=True)
        self.heartbeat_path.write_text(datetime.now(timezone.utc).isoformat())

    def _collect_due(self, now: datetime) -> list[SyntheticJob]:
        out: list[SyntheticJob] = []
        for j in self.scheduler.due_jobs(now):
            out.append(SyntheticJob(id=j.id, agent=j.agent, prompt=j.prompt,
                                     priority=j.priority, notify_on=j.notify_on,
                                     source="scheduled", source_ref=j))
        if self.calendar:
            try:
                alerts = self.calendar.generate_alerts(now.date())
            except Exception as e:
                self._log("calendar_error", error=str(e))
                alerts = []
            for a in alerts:
                out.append(SyntheticJob(id=a.id, agent=a.agent, prompt=a.prompt,
                                         priority=a.priority, notify_on=a.notify_on,
                                         source="calendar", source_ref=a))
        try:
            triggers = self.reactive.pending_triggers()
        except Exception as e:
            self._log("reactive_error", error=str(e))
            triggers = []
        for t in triggers:
            out.append(SyntheticJob(id=f"reactive-{t.id}", agent=t.agent, prompt=t.prompt,
                                     priority=t.priority, notify_on=t.notify_on,
                                     source="reactive", source_ref=t))
        return out

    def _should_notify(self, sj: SyntheticJob, stage: str) -> bool:
        """stage in {'start', 'completion', 'failure', 'critical_alert', 'critical_findings'}"""
        # Failures ALWAYS notify (critical invariant), regardless of notify_on
        if stage == "failure":
            return True
        if stage == "start":
            return sj.priority in ("high", "critical")
        return stage in sj.notify_on

    async def _notify(self, sj: SyntheticJob, stage: str, text: str) -> None:
        if not self.marty_chat_id: return
        if not self._should_notify(sj, stage): return
        priority = "critical" if stage in ("critical_alert", "critical_findings", "failure") and sj.priority == "critical" \
                   else ("critical" if stage == "critical_alert" or stage == "critical_findings" \
                         else sj.priority)
        await self.telegram.notify(self.marty_chat_id, text, priority=priority)

    async def _execute(self, sj: SyntheticJob) -> None:
        started = datetime.now(timezone.utc)
        self._log("job_start", job_id=sj.id, agent=sj.agent, source=sj.source, priority=sj.priority)
        await self._notify(sj, "start", f"Démarrage `{sj.id}`\nagent: `{sj.agent or 'main'}` · source: {sj.source}")

        # F8: move reactive trigger to inflight before execution to prevent duplicate on crash
        if sj.source == "reactive":
            self.reactive.checkout(sj.source_ref)

        if self.dry_run:
            # Simulate success without hitting claude
            result = RunResult(job_id=sj.id, agent=sj.agent, exit_code=0,
                               stdout="[dry-run] stdout", stderr="", duration_ms=0,
                               timed_out=False, started_at=started.isoformat())
        else:
            result = await self.claude.run(job_id=sj.id, prompt=sj.prompt, agent=sj.agent)

        success = (result.exit_code == 0 and not result.timed_out)
        report_path = self._write_report(sj, result, started)

        # Post-run hooks per source
        if sj.source == "scheduled":
            self.scheduler.advance(sj.source_ref, success=success, now=datetime.now(timezone.utc))
        elif sj.source == "calendar":
            self.calendar.mark_fired(sj.source_ref.id) if self.calendar else None
        elif sj.source == "reactive":
            summary = (result.stdout or "")[:160].replace("\n", " ")
            self.reactive.ack(sj.source_ref, success=success, result_summary=summary)

        self._log("job_end", job_id=sj.id, exit=result.exit_code, dur_ms=result.duration_ms,
                  success=success, timed_out=result.timed_out, report=str(report_path))

        # Notifications post-run
        if success:
            await self._notify(sj, "completion",
                f"✓ `{sj.id}` terminé en {result.duration_ms}ms\nRapport: `{report_path.name}`")
        else:
            stage = "failure"
            reason = "timeout" if result.timed_out else f"exit={result.exit_code}"
            await self._notify(sj, "failure",
                f"✗ `{sj.id}` échoué ({reason})\nstderr: `{_safe_excerpt(result.stderr, 300)}`")
        # Critical scan of stdout — require exact CRITICAL: at start of line to prevent injection forge
        if success and result.stdout and re.search(r"(?m)^CRITICAL:", result.stdout):
            await self._notify(sj, "critical_alert",
                f"🚨 `{sj.id}` signale CRITICAL\n{_safe_excerpt(result.stdout, 500)}")

    def _write_report(self, sj: SyntheticJob, result: RunResult, started: datetime) -> Path:
        day = started.date().isoformat()
        day_dir = self.reports_dir / day
        day_dir.mkdir(parents=True, exist_ok=True)
        name = f"{started.strftime('%H%M%S')}-{sj.id}.md"
        path = day_dir / name
        body = f"""# KAIROS run: {sj.id}

- **Started:** {started.isoformat()}
- **Agent:** {sj.agent or '(main session)'}
- **Source:** {sj.source}
- **Priority:** {sj.priority}
- **Exit:** {result.exit_code}
- **Duration:** {result.duration_ms} ms
- **Timed out:** {result.timed_out}

## Prompt
```
{sj.prompt}
```

## stdout
```
{(result.stdout or '')[:8000]}
```

## stderr
```
{(result.stderr or '')[:4000]}
```
"""
        path.write_text(body)
        return path

    async def _tick(self) -> None:
        now = datetime.now(timezone.utc)
        due = self._collect_due(now)
        if due:
            self._log("tick_due", count=len(due), ids=[j.id for j in due])
        for sj in due:
            task = asyncio.create_task(self._execute(sj), name=f"job-{sj.id}")
            self._inflight.add(task)
            task.add_done_callback(self._inflight.discard)

    async def _heartbeat_loop(self):
        while not self._shutdown.is_set():
            try:
                self._heartbeat()
            except Exception as e:
                self._log("heartbeat_error", error=str(e))
            try:
                await asyncio.wait_for(self._shutdown.wait(), timeout=30)
            except asyncio.TimeoutError:
                pass

    async def run(self) -> None:
        self._log("daemon_start", pid=os.getpid(), config=self.config_path, dry_run=self.dry_run)
        loop = asyncio.get_running_loop()
        for sig in (signal.SIGTERM, signal.SIGINT):
            loop.add_signal_handler(sig, self._shutdown.set)

        hb_task = asyncio.create_task(self._heartbeat_loop())
        try:
            while not self._shutdown.is_set():
                try:
                    await self._tick()
                except Exception as e:
                    self._log("tick_error", error=str(e))
                try:
                    await asyncio.wait_for(self._shutdown.wait(), timeout=self.tick_interval)
                except asyncio.TimeoutError:
                    pass
        finally:
            hb_task.cancel()
            try:
                await hb_task
            except asyncio.CancelledError:
                pass
            # Graceful drain
            if self._inflight:
                self._log("draining", inflight=len(self._inflight))
                try:
                    await asyncio.wait_for(asyncio.gather(*self._inflight, return_exceptions=True), timeout=60)
                except asyncio.TimeoutError:
                    self._log("drain_timeout", inflight=len(self._inflight))
            self._log("daemon_stop")

    async def self_test(self) -> int:
        """Bounded startup test: 1 tick with dry-run, then exit."""
        self._log("self_test_start")
        self._heartbeat()
        await self._tick()
        # wait a bit for tasks to settle
        if self._inflight:
            await asyncio.wait(self._inflight, timeout=10)
        self._log("self_test_end")
        return 0

def main() -> int:
    p = argparse.ArgumentParser(prog="kairos", description="OctoPulse autonomous tick loop")
    p.add_argument("--config", default=os.path.expanduser("~/octopulse/kairos/config.yml"))
    p.add_argument("--dry-run", action="store_true", help="Skip claude calls, simulate success")
    p.add_argument("--self-test", action="store_true", help="Run 1 tick in dry-run then exit")
    args = p.parse_args()

    if args.self_test:
        args.dry_run = True
        k = Kairos(args.config, dry_run=True)
        return asyncio.run(k.self_test())
    k = Kairos(args.config, dry_run=args.dry_run)
    asyncio.run(k.run())
    return 0

if __name__ == "__main__":
    sys.exit(main())
