#!/bin/bash
# Master nightly docs refresh — called by systemd timer
set -e
export PATH="$HOME/.bun/bin:$HOME/.local/bin:$PATH"
INTEGRATIONS="$HOME/octopulse/integrations"
LOG="$HOME/logs/integrations/nightly-refresh.log"
mkdir -p "$(dirname $LOG)"

echo "[$(date -Iseconds)] === NIGHTLY DOCS REFRESH START ===" >> "$LOG"

# Fetch each API that has a fetcher script
for api in meta-ads printful klaviyo posthog; do
  FETCHER="$INTEGRATIONS/scripts/fetch-${api}.sh"
  if [ -x "$FETCHER" ]; then
    echo "[$(date -Iseconds)] Fetching $api..." >> "$LOG"
    "$FETCHER" >> "$LOG" 2>&1 || echo "[$(date -Iseconds)] WARN: fetch-${api} failed (exit $?)" >> "$LOG"
  else
    echo "[$(date -Iseconds)] SKIP $api (no fetcher script)" >> "$LOG"
  fi
done

# Snapshot for diff (7 day rotation)
SNAPSHOT_DIR="$INTEGRATIONS/docs/_snapshots"
mkdir -p "$SNAPSHOT_DIR"
TODAY=$(date +%F)
tar czf "$SNAPSHOT_DIR/docs-${TODAY}.tar.gz" -C "$INTEGRATIONS" docs/ 2>/dev/null || true
# Rotate: keep 7 days
find "$SNAPSHOT_DIR" -name "docs-*.tar.gz" -mtime +7 -delete 2>/dev/null

# Detect breaking changes
"$INTEGRATIONS/scripts/detect-breaking-changes.sh" >> "$LOG" 2>&1 || {
  EXIT_CODE=$?
  if [ $EXIT_CODE -eq 2 ]; then
    echo "[$(date -Iseconds)] BREAKING CHANGE DETECTED — alerting Marty" >> "$LOG"
    # Telegram alert
    cd "$HOME/octopulse/kairos"
    ./venv/bin/python3 telegram_notifier.py "7234705861" \
      "⚠️ BREAKING CHANGE API détecté pendant le refresh nightly. Voir $LOG pour détails." \
      "critical" 2>/dev/null || true
  fi
}

# Re-index ClawMem
echo "[$(date -Iseconds)] Re-indexing ClawMem..." >> "$LOG"
"$INTEGRATIONS/scripts/index-all-docs.sh" >> "$LOG" 2>&1

echo "[$(date -Iseconds)] === NIGHTLY REFRESH COMPLETE ===" >> "$LOG"
