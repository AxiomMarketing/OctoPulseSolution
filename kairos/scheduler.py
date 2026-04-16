"""KAIROS cron-driven job scheduler with persistent state overlay."""
import json, os, sys
from dataclasses import dataclass, field, asdict
from datetime import datetime, timezone, tzinfo
from pathlib import Path
from typing import Any, Optional
from zoneinfo import ZoneInfo
import yaml
from croniter import croniter

LOCAL_TZ = ZoneInfo("Indian/Reunion")

@dataclass
class Job:
    id: str
    agent: Optional[str]
    cron: str
    prompt: str
    priority: str = "normal"
    notify_on: list[str] = field(default_factory=list)
    enabled: bool = True

    @classmethod
    def from_dict(cls, d: dict) -> "Job":
        prompt = (d.get("prompt") or "").strip()
        if not prompt:
            raise ValueError(f"job {d.get('id', '?')} has empty prompt")
        return cls(
            id=d["id"], agent=d.get("agent"), cron=d["cron"],
            prompt=prompt, priority=d.get("priority", "normal"),
            notify_on=d.get("notify_on", ["failure"]),
            enabled=d.get("enabled", True),
        )

@dataclass
class JobState:
    enabled: bool = True
    last_run: Optional[str] = None   # ISO UTC
    next_run: Optional[str] = None   # ISO UTC
    run_count: int = 0
    fail_count: int = 0

class Scheduler:
    def __init__(self, config_path: str, state_path: str = None):
        self.config_path = Path(os.path.expanduser(config_path))
        self.state_path = Path(os.path.expanduser(
            state_path or str(self.config_path.parent / "state.json")))
        self.jobs: dict[str, Job] = {}
        self.state: dict[str, JobState] = {}
        self.tick_interval_sec = 60
        self.reload()

    def reload(self) -> None:
        with self.config_path.open() as f:
            cfg = yaml.safe_load(f) or {}
        self.tick_interval_sec = cfg.get("kairos", {}).get("tick_interval_sec", 60)
        self.jobs = {}
        for j in cfg.get("jobs", []) or []:
            job = Job.from_dict(j)
            self.jobs[job.id] = job
        self._load_state()
        self._initialize_next_runs()

    def _load_state(self) -> None:
        if self.state_path.exists():
            try:
                raw = json.loads(self.state_path.read_text())
                self.state = {k: JobState(**v) for k, v in raw.items()}
            except Exception as e:
                print(f"state.json load failed, resetting: {e}", file=sys.stderr)
                self.state = {}
        for job_id in self.jobs:
            self.state.setdefault(job_id, JobState())

    def _save_state(self) -> None:
        self.state_path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.state_path.with_suffix(f".{os.getpid()}.tmp")
        tmp.write_text(json.dumps({k: asdict(v) for k, v in self.state.items()},
                                  indent=2, ensure_ascii=False))
        tmp.replace(self.state_path)

    def _initialize_next_runs(self) -> None:
        now = datetime.now(LOCAL_TZ)
        for job_id, job in self.jobs.items():
            st = self.state[job_id]
            if not st.next_run:
                st.next_run = croniter(job.cron, now).get_next(datetime).astimezone(LOCAL_TZ).isoformat()
        self._save_state()

    def due_jobs(self, now: Optional[datetime] = None) -> list[Job]:
        now = now or datetime.now(LOCAL_TZ)
        out = []
        for job_id, job in self.jobs.items():
            st = self.state[job_id]
            if not st.enabled or not job.enabled:
                continue
            if st.next_run and datetime.fromisoformat(st.next_run) <= now:
                out.append(job)
        return out

    def advance(self, job: Job, success: bool = True, now: Optional[datetime] = None) -> None:
        now = now or datetime.now(LOCAL_TZ)
        st = self.state[job.id]
        st.last_run = now.isoformat()
        st.run_count += 1
        if not success:
            st.fail_count += 1
        st.next_run = croniter(job.cron, now).get_next(datetime).astimezone(LOCAL_TZ).isoformat()
        self._save_state()

    def mark_enabled(self, job_id: str, enabled: bool) -> bool:
        if job_id not in self.state:
            return False
        self.state[job_id].enabled = enabled
        self._save_state()
        return True

    def status(self) -> dict[str, Any]:
        return {
            "jobs_total": len(self.jobs),
            "enabled": sum(1 for s in self.state.values() if s.enabled),
            "jobs": [
                {"id": jid, "cron": self.jobs[jid].cron, "enabled": self.state[jid].enabled,
                 "last_run": self.state[jid].last_run, "next_run": self.state[jid].next_run,
                 "run_count": self.state[jid].run_count, "fail_count": self.state[jid].fail_count}
                for jid in self.jobs
            ],
        }

if __name__ == "__main__":
    import sys
    s = Scheduler(sys.argv[1] if len(sys.argv) > 1 else "config.example.yml")
    print(json.dumps(s.status(), indent=2))
    print("\nDue now:", [j.id for j in s.due_jobs()])
