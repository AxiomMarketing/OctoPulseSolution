"""KAIROS claude -p subprocess wrapper with semaphore + logging."""
import asyncio, json, os, re, time
from dataclasses import dataclass, asdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional

AGENT_RE = re.compile(r"^[a-z][a-z0-9_-]{0,31}$")

@dataclass
class RunResult:
    job_id: str
    agent: Optional[str]
    exit_code: int
    stdout: str
    stderr: str
    duration_ms: int
    timed_out: bool
    started_at: str  # ISO UTC

class ClaudeRunner:
    def __init__(self, *, binary: str = "claude", flags: list[str] = None,
                 working_dir: str = None, timeout_sec: int = 900,
                 max_concurrent: int = 3, log_dir: str = None,
                 retry_count: int = 1, retry_backoff_sec: int = 30):
        self.binary = binary
        self.flags = flags or ["--dangerously-skip-permissions"]
        self.working_dir = os.path.expanduser(working_dir or os.getcwd())
        self.timeout_sec = timeout_sec
        self.retry_count = retry_count
        self.retry_backoff_sec = retry_backoff_sec
        self.log_dir = Path(os.path.expanduser(log_dir or "~/logs/kairos")) / "runs"
        self.log_dir.mkdir(parents=True, exist_ok=True)
        self._sem = asyncio.Semaphore(max_concurrent)

    async def run(self, *, job_id: str, prompt: str, agent: Optional[str] = None,
                  extra_flags: list[str] = None) -> RunResult:
        async with self._sem:
            return await self._run_with_retry(job_id, prompt, agent, extra_flags or [])

    async def _run_with_retry(self, job_id, prompt, agent, extra_flags):
        last = None
        for attempt in range(self.retry_count + 1):
            last = await self._run_once(job_id, prompt, agent, extra_flags)
            # Only retry on timeout (idempotent failure mode)
            if last.exit_code == 0 or not last.timed_out:
                return last
            if attempt < self.retry_count:
                await asyncio.sleep(self.retry_backoff_sec)
        return last

    async def _run_once(self, job_id, prompt, agent, extra_flags) -> RunResult:
        if agent is not None and not AGENT_RE.match(agent):
            return RunResult(
                job_id=job_id, agent=agent, exit_code=-2,
                stdout="", stderr=f"invalid agent name: {agent!r}",
                duration_ms=0, timed_out=False,
                started_at=datetime.now(timezone.utc).isoformat(),
            )
        cmd = [self.binary, "-p", prompt, *self.flags, "--add-dir", self.working_dir, *extra_flags]
        if agent:
            cmd += ["--agent", agent]
        started_at = datetime.now(timezone.utc).isoformat()
        t0 = time.monotonic()
        proc = await asyncio.create_subprocess_exec(
            *cmd, cwd=self.working_dir,
            stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE,
        )
        timed_out = False
        try:
            stdout_b, stderr_b = await asyncio.wait_for(proc.communicate(), timeout=self.timeout_sec)
        except asyncio.TimeoutError:
            timed_out = True
            proc.kill()
            stdout_b, stderr_b = await proc.communicate()
        duration_ms = int((time.monotonic() - t0) * 1000)
        result = RunResult(
            job_id=job_id, agent=agent,
            exit_code=proc.returncode if proc.returncode is not None else -1,
            stdout=(stdout_b or b"").decode("utf-8", errors="replace"),
            stderr=(stderr_b or b"").decode("utf-8", errors="replace"),
            duration_ms=duration_ms, timed_out=timed_out, started_at=started_at,
        )
        self._log_run(result)
        return result

    def _log_run(self, r: RunResult) -> None:
        day = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        path = self.log_dir / f"{day}.jsonl"
        record = asdict(r)
        # truncate stdout/stderr in log to keep size reasonable
        record["stdout_len"] = len(r.stdout)
        record["stderr_len"] = len(r.stderr)
        record["stdout"] = r.stdout[:500]
        record["stderr"] = r.stderr[:500]
        with path.open("a") as f:
            f.write(json.dumps(record, ensure_ascii=False) + "\n")

if __name__ == "__main__":
    # Dry-run: simulate a short prompt. Uses real `claude` binary.
    import sys
    async def main():
        r = ClaudeRunner(working_dir="~/octopulse", timeout_sec=30, max_concurrent=1)
        res = await r.run(job_id="dryrun", prompt="Say OK and nothing else.")
        print(f"exit={res.exit_code} duration={res.duration_ms}ms stdout[:80]={res.stdout[:80]!r}")
    asyncio.run(main())
