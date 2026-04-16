from datetime import date
from pathlib import Path
import pytest
from calendar_engine import parse_calendar, CalendarEngine

FIXTURE = "tests/fixtures/calendar.md"


def test_parse_markdown_table():
    events = parse_calendar(FIXTURE)
    assert len(events) == 3
    names = [e.name for e in events]
    assert "Test J-30" in names
    assert any(e.date == date(2026, 5, 15) for e in events)


def test_parse_yaml_frontmatter(tmp_path):
    f = tmp_path / "cal.md"
    f.write_text(
        "---\nevents:\n"
        "  - date: 2026-12-24\n    name: Noël eve\n    category: commerciale\n    priority: high\n"
        "---\n# anything\n"
    )
    events = parse_calendar(str(f))
    assert len(events) == 1
    assert events[0].name == "Noël eve"
    assert events[0].priority == "high"


def test_lead_time_alerts(tmp_path):
    lts = [{
        "days": 30, "agents": ["forge", "maeva"],
        "prompt_template": "{name} ({date}, {category})",
    }]
    eng = CalendarEngine(source=FIXTURE, lead_times_config=lts,
                         fired_path=str(tmp_path / "fired.json"))
    alerts = eng.generate_alerts(today=date(2026, 4, 15))
    assert len(alerts) == 2
    agents = sorted(a.agent for a in alerts)
    assert agents == ["forge", "maeva"]
    assert all("Test J-30" in a.prompt for a in alerts)


def test_no_double_fire(tmp_path):
    lts = [{
        "days": 30, "agents": ["forge", "maeva"],
        "prompt_template": "{name}",
    }]
    eng = CalendarEngine(source=FIXTURE, lead_times_config=lts,
                         fired_path=str(tmp_path / "fired.json"))
    alerts = eng.generate_alerts(today=date(2026, 4, 15))
    for a in alerts:
        eng.mark_fired(a.id)
    alerts2 = eng.generate_alerts(today=date(2026, 4, 15))
    assert alerts2 == []
