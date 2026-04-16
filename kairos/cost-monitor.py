#!/usr/bin/env python3
"""Cost monitor : vérifie usage API Anthropic des 24h glissantes, alerte Telegram si > seuil."""
import json, os, sys, asyncio
from datetime import datetime, timedelta, timezone
from pathlib import Path

# Add kairos dir to path pour utiliser telegram_notifier
sys.path.insert(0, os.path.expanduser("~/octopulse/kairos"))
from telegram_notifier import TelegramNotifier

DAILY_ALERT_USD = float(os.environ.get("COST_DAILY_ALERT_USD", "20"))
LOG_DIR = Path(os.path.expanduser("~/logs/kairos"))
LOG_FILE = LOG_DIR / "cost-monitor.jsonl"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def estimate_usage_from_local_logs() -> dict:
    """
    Calcule usage approximatif depuis les logs Claude Code locaux et runs KAIROS.
    MVP : compte les runs des 24h + estimate token volume.

    Return : {"runs_24h": int, "estimated_tokens": int, "estimated_usd": float}
    """
    now = datetime.now(timezone.utc)
    start = now - timedelta(hours=24)

    runs_count = 0
    estimated_tokens = 0

    # Parse les JSONL runs KAIROS des 2 derniers jours
    runs_log_dir = Path(os.path.expanduser("~/logs/kairos/runs"))
    if runs_log_dir.exists():
        for logfile in runs_log_dir.glob("*.jsonl"):
            try:
                for line in logfile.read_text().splitlines():
                    entry = json.loads(line)
                    ts_str = entry.get("started_at", "")
                    try:
                        ts = datetime.fromisoformat(ts_str.replace("Z", "+00:00"))
                    except Exception:
                        continue
                    if ts >= start:
                        runs_count += 1
                        # Rough estimate : 5k tokens per run (conservatif)
                        estimated_tokens += 5000
            except Exception:
                continue

    # Pricing Anthropic Opus 4.6 (approximatif avril 2026) : ~$45/1M tokens moyenne input+output
    estimated_usd = (estimated_tokens / 1_000_000) * 45

    return {
        "runs_24h": runs_count,
        "estimated_tokens": estimated_tokens,
        "estimated_usd": round(estimated_usd, 2),
    }


def main():
    usage = estimate_usage_from_local_logs()
    now = datetime.now(timezone.utc).isoformat()

    record = {
        "ts": now,
        **usage,
        "threshold_usd": DAILY_ALERT_USD,
        "alert": usage["estimated_usd"] > DAILY_ALERT_USD,
    }

    with LOG_FILE.open("a") as f:
        f.write(json.dumps(record) + "\n")

    print(json.dumps(record, indent=2))

    notifier = TelegramNotifier()
    chat_id = "7234705861"  # Marty

    if record["alert"]:
        text = (
            f"Dépassement seuil coûts API Anthropic\n\n"
            f"Usage estimé 24h : *${usage['estimated_usd']}*\n"
            f"Seuil : ${DAILY_ALERT_USD}\n"
            f"Runs KAIROS : {usage['runs_24h']}\n"
            f"Tokens estimés : {usage['estimated_tokens']:,}\n\n"
            f"Logs : ~/logs/kairos/cost-monitor.jsonl"
        )
        asyncio.run(notifier.notify(chat_id, text, priority="high"))


if __name__ == "__main__":
    main()
