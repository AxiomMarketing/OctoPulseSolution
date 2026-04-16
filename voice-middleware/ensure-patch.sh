#!/bin/bash
# Hook SessionStart: s'assure que le patch voice est applique.
# Idempotent et silencieux (n'interrompt jamais le startup).
set +e

PATCH_SCRIPT="$HOME/octopulse/voice-middleware/apply-patch.sh"
[ -x "$PATCH_SCRIPT" ] || exit 0

LOG="$HOME/logs/voice-middleware/ensure-patch.log"
mkdir -p "$(dirname "$LOG")"

# Detecter la version du plugin (si plusieurs versions presentes, prendre la plus recente)
PLUGIN_BASE="$HOME/.claude/plugins/cache/claude-plugins-official/telegram"
if [ -d "$PLUGIN_BASE" ]; then
  VERSION=$(ls -1 "$PLUGIN_BASE" 2>/dev/null | sort -V | tail -1)
  if [ -n "$VERSION" ]; then
    export PLUGIN_VERSION="$VERSION"
    "$PATCH_SCRIPT" >> "$LOG" 2>&1 || echo "$(date -Iseconds) [warn] apply-patch exit=$?" >> "$LOG"
  fi
fi

exit 0
