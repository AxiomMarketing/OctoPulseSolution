"""KAIROS calendar-driven alert generator (J-45/J-30/J-14 lead times)."""
import json, os, re, sys
from dataclasses import dataclass, asdict, field
from datetime import date, datetime, timezone
from pathlib import Path
from typing import Any, Optional
import yaml
import frontmatter

@dataclass
class CalendarEvent:
    date: date
    name: str
    category: str = ""
    priority: str = "normal"

    @property
    def id(self) -> str:
        safe = re.sub(r"[^a-z0-9]+", "-", self.name.lower()).strip("-")
        return f"{self.date.isoformat()}-{safe}"

@dataclass
class Alert:
    id: str              # f"{event.id}__J{lead_days}__{agent}"
    event_id: str
    event_name: str
    event_date: str      # iso
    lead_days: int
    agent: str
    prompt: str
    priority: str = "normal"
    notify_on: list[str] = field(default_factory=lambda: ["failure"])

    def as_job_dict(self) -> dict[str, Any]:
        return {"id": self.id, "agent": self.agent, "cron": "",
                "prompt": self.prompt, "priority": self.priority,
                "notify_on": self.notify_on, "enabled": True}

TABLE_ROW_RE = re.compile(r"^\|\s*(\d{4}-\d{2}-\d{2})\s*\|\s*([^|]+?)\s*\|\s*([^|]*?)\s*\|\s*([^|]*?)\s*\|\s*$")

def parse_calendar(path: str) -> list[CalendarEvent]:
    p = Path(os.path.expanduser(path))
    text = p.read_text()
    events: list[CalendarEvent] = []
    # Try frontmatter first
    try:
        fm = frontmatter.loads(text)
        ev_list = fm.metadata.get("events") if fm.metadata else None
        if isinstance(ev_list, list):
            for raw in ev_list:
                d = raw.get("date")
                if isinstance(d, str): d = date.fromisoformat(d)
                events.append(CalendarEvent(
                    date=d, name=raw.get("name", "").strip(),
                    category=raw.get("category", ""), priority=raw.get("priority", "normal"),
                ))
            if events:
                return events
    except Exception as e:
        print(f"calendar frontmatter parse skipped: {e}", file=sys.stderr)
    # Fallback: markdown table
    for line in text.splitlines():
        m = TABLE_ROW_RE.match(line.strip())
        if not m: continue
        try:
            d = date.fromisoformat(m.group(1))
            events.append(CalendarEvent(
                date=d, name=m.group(2).strip(),
                category=m.group(3).strip(), priority=m.group(4).strip() or "normal",
            ))
        except ValueError:
            continue
    return events

class CalendarEngine:
    def __init__(self, *, source: str, lead_times_config: list[dict],
                 fired_path: str = None):
        self.source = os.path.expanduser(source)
        self.lead_times = lead_times_config
        self.fired_path = Path(os.path.expanduser(
            fired_path or "~/octopulse/kairos/calendar_fired.json"))
        self.fired: dict[str, str] = {}
        if self.fired_path.exists():
            try:
                self.fired = json.loads(self.fired_path.read_text())
            except Exception as e:
                print(f"calendar_fired.json load failed, resetting: {e}", file=sys.stderr)
                self.fired = {}

    def _persist_fired(self) -> None:
        self.fired_path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.fired_path.with_suffix(f".{os.getpid()}.tmp")
        tmp.write_text(json.dumps(self.fired, indent=2, ensure_ascii=False))
        tmp.replace(self.fired_path)

    def generate_alerts(self, today: Optional[date] = None) -> list[Alert]:
        today = today or datetime.now(timezone.utc).date()
        if not Path(self.source).exists():
            return []
        events = parse_calendar(self.source)
        alerts: list[Alert] = []
        for event in events:
            delta = (event.date - today).days
            for lt in self.lead_times:
                if delta != lt["days"]:
                    continue
                for agent in lt.get("agents", []):
                    alert_id = f"{event.id}__J{lt['days']}__{agent}"
                    if alert_id in self.fired:
                        continue
                    prompt = lt["prompt_template"].format(
                        name=event.name, date=event.date.isoformat(),
                        category=event.category or "n/a",
                    ).strip()
                    if not prompt:
                        continue
                    alerts.append(Alert(
                        id=alert_id, event_id=event.id, event_name=event.name,
                        event_date=event.date.isoformat(), lead_days=lt["days"],
                        agent=agent, prompt=prompt, priority=event.priority,
                        notify_on=["failure"],
                    ))
        return alerts

    def mark_fired(self, alert_id: str) -> None:
        self.fired[alert_id] = datetime.now(timezone.utc).isoformat()
        self._persist_fired()

def load_engine_from_config(config_path: str) -> Optional[CalendarEngine]:
    with open(os.path.expanduser(config_path)) as f:
        cfg = yaml.safe_load(f) or {}
    cal_cfg = cfg.get("calendar")
    if not cal_cfg or not cal_cfg.get("source"):
        return None
    return CalendarEngine(source=cal_cfg["source"], lead_times_config=cal_cfg.get("lead_times", []))

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: calendar_engine.py <calendar.md> [--today YYYY-MM-DD]")
        sys.exit(1)
    source = sys.argv[1]
    today = None
    if "--today" in sys.argv:
        today = date.fromisoformat(sys.argv[sys.argv.index("--today") + 1])
    events = parse_calendar(source)
    print(f"Parsed {len(events)} events from {source}")
    for e in events:
        print(f"  {e.date} | {e.name} ({e.category}, {e.priority})")
    # Example lead_times for standalone test
    demo_lts = [
        {"days": 30, "agents": ["forge", "maeva"],
         "prompt_template": "Événement {name} dans 30j ({date}, {category}). Brief."},
    ]
    eng = CalendarEngine(source=source, lead_times_config=demo_lts,
                         fired_path="/tmp/kairos-fired-test.json")
    alerts = eng.generate_alerts(today)
    print(f"\n{len(alerts)} alerts generated:")
    for a in alerts:
        print(f"  {a.id}\n    -> {a.prompt[:100]}")
