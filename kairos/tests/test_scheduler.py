import json
from datetime import datetime, timezone
import pytest
from scheduler import Scheduler

CONFIG = "config.example.yml"


def fresh_scheduler(tmp_path):
    state = tmp_path / "state.json"
    return Scheduler(CONFIG, state_path=str(state))


def test_load_example_config(tmp_path):
    s = fresh_scheduler(tmp_path)
    assert len(s.jobs) == 1
    assert "example-daily" in s.jobs


def test_cron_due_at_match(tmp_path):
    s = fresh_scheduler(tmp_path)
    jid = "example-daily"
    s.state[jid].next_run = "2020-01-01T00:00:00+00:00"
    s._save_state()
    due = s.due_jobs(datetime.now(timezone.utc))
    assert any(j.id == jid for j in due)


def test_disabled_job_not_due(tmp_path):
    s = fresh_scheduler(tmp_path)
    jid = "example-daily"
    s.state[jid].next_run = "2020-01-01T00:00:00+00:00"
    s.mark_enabled(jid, False)
    due = s.due_jobs(datetime.now(timezone.utc))
    assert all(j.id != jid for j in due)


def test_advance_updates_state(tmp_path):
    s = fresh_scheduler(tmp_path)
    jid = "example-daily"
    job = s.jobs[jid]
    before_count = s.state[jid].run_count
    s.advance(job, success=True)
    assert s.state[jid].run_count == before_count + 1
    assert s.state[jid].fail_count == 0
    assert s.state[jid].last_run is not None
    persisted = json.loads((tmp_path / "state.json").read_text())
    assert persisted[jid]["run_count"] == s.state[jid].run_count


def test_fail_count_increments(tmp_path):
    s = fresh_scheduler(tmp_path)
    jid = "example-daily"
    job = s.jobs[jid]
    s.advance(job, success=False)
    assert s.state[jid].fail_count == 1
