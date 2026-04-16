"""KAIROS reactive trigger watcher — YAML files dropped by agents/CLI."""
import json, os, shutil, uuid
from dataclasses import dataclass, field
from datetime import datetime, date, timezone
from pathlib import Path
from typing import Any
import yaml


@dataclass
class Trigger:
    id: str
    agent: str
    prompt: str
    priority: str = "normal"
    submitter: str = "unknown"
    created_at: str = ""
    notify_on: list[str] = field(default_factory=lambda: ["completion", "failure"])
    source_path: str = ""  # filled at load time

    def as_job_dict(self) -> dict[str, Any]:
        return {
            "id": f"reactive-{self.id}", "agent": self.agent, "cron": "",
            "prompt": self.prompt, "priority": self.priority,
            "notify_on": self.notify_on, "enabled": True,
        }

REQUIRED = ("id", "agent", "prompt")

class ReactiveWatcher:
    def __init__(self, *, inbox: str, processed: str, invalid: str,
                 max_per_tick: int = 10):
        self.inbox = Path(os.path.expanduser(inbox))
        self.processed = Path(os.path.expanduser(processed))
        self.invalid = Path(os.path.expanduser(invalid))
        self.inflight = Path(os.path.expanduser(inbox)).parent / "inflight"
        self.max_per_tick = max_per_tick
        for d in (self.inbox, self.processed, self.invalid, self.inflight):
            d.mkdir(parents=True, exist_ok=True)

    def pending_triggers(self) -> list[Trigger]:
        files = sorted([p for p in self.inbox.iterdir()
                        if p.is_file() and p.suffix in (".yml", ".yaml")])
        out: list[Trigger] = []
        for p in files[: self.max_per_tick]:
            try:
                raw = yaml.safe_load(p.read_text()) or {}
            except Exception as e:
                self._move_invalid(p, f"yaml parse error: {e}")
                continue
            missing = [k for k in REQUIRED if not raw.get(k)]
            if missing:
                self._move_invalid(p, f"missing required keys: {missing}")
                continue
            t = Trigger(
                id=str(raw["id"]),
                agent=str(raw["agent"]),
                prompt=str(raw["prompt"]),
                priority=str(raw.get("priority", "normal")),
                submitter=str(raw.get("submitter", "unknown")),
                created_at=str(raw.get("created_at", "")),
                notify_on=raw.get("notify_on", ["completion", "failure"]),
                source_path=str(p),
            )
            out.append(t)
        return out

    def ack(self, trigger: Trigger, *, success: bool = True,
            result_summary: str | None = None) -> None:
        src = Path(trigger.source_path)
        if not src.exists(): return
        day = datetime.now(timezone.utc).date().isoformat()
        dst_dir = self.processed / day
        dst_dir.mkdir(parents=True, exist_ok=True)
        dst = dst_dir / src.name
        meta = {
            "processed_at": datetime.now(timezone.utc).isoformat(),
            "success": success, "result_summary": result_summary or "",
        }
        content = src.read_text()
        content += f"\n\n---\n# KAIROS processing meta\n{yaml.safe_dump(meta, allow_unicode=True)}"
        dst.write_text(content)
        src.unlink()

    def checkout(self, trigger: Trigger) -> None:
        """Move trigger file from inbox to inflight before execution."""
        src = Path(trigger.source_path)
        if not src.exists():
            return
        dst = self.inflight / src.name
        src.rename(dst)
        trigger.source_path = str(dst)

    def recover_inflight(self) -> list[Trigger]:
        """On startup, re-queue inflight files (they were interrupted)."""
        triggers = []
        for p in sorted(self.inflight.iterdir()):
            if p.is_file() and p.suffix in (".yml", ".yaml"):
                try:
                    raw = yaml.safe_load(p.read_text()) or {}
                    if all(raw.get(k) for k in REQUIRED):
                        dst = self.inbox / p.name
                        p.rename(dst)
                except Exception:
                    # Leave in inflight for operator inspection
                    pass
        return triggers

    def _move_invalid(self, path: Path, reason: str) -> None:
        self.invalid.mkdir(parents=True, exist_ok=True)
        dst = self.invalid / path.name
        dst.write_text(f"# INVALID: {reason}\n" + path.read_text())
        path.unlink()

    def drop_trigger(self, *, agent: str, prompt: str, priority: str = "normal",
                     submitter: str = "kairos-ctl") -> Path:
        """Helper for CLI to write a new trigger into the inbox."""
        tid = f"{datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')}-{uuid.uuid4().hex[:6]}"
        payload = {
            "id": tid, "agent": agent, "prompt": prompt,
            "priority": priority, "submitter": submitter,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }
        out = self.inbox / f"{tid}.yml"
        out.write_text(yaml.safe_dump(payload, allow_unicode=True))
        return out

def load_watcher_from_config(config_path: str) -> ReactiveWatcher:
    with open(os.path.expanduser(config_path)) as f:
        cfg = yaml.safe_load(f) or {}
    r = cfg.get("reactive", {}) or {}
    return ReactiveWatcher(
        inbox=r.get("inbox_dir", "~/octopulse/kairos/triggers/inbox"),
        processed=r.get("processed_dir", "~/octopulse/kairos/triggers/processed"),
        invalid=r.get("invalid_dir", "~/octopulse/kairos/triggers/invalid"),
        max_per_tick=r.get("max_per_tick", 10),
    )

if __name__ == "__main__":
    import sys
    if "--demo" in sys.argv:
        w = ReactiveWatcher(
            inbox="~/octopulse/kairos/triggers/inbox",
            processed="~/octopulse/kairos/triggers/processed",
            invalid="~/octopulse/kairos/triggers/invalid",
        )
        p = w.drop_trigger(agent="atlas", prompt="demo test ping", priority="debug",
                           submitter="reactive.py --demo")
        print(f"Dropped: {p}")
        triggers = w.pending_triggers()
        print(f"Pending: {len(triggers)}")
        for t in triggers:
            print(f"  {t.id} agent={t.agent} priority={t.priority}")
            w.ack(t, success=True, result_summary="demo processed")
        print("Ack'd. Check triggers/processed/")
