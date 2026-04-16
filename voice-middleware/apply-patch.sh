#!/bin/bash
# Applique le patch voice-transcription sur le plugin Telegram officiel
# Idempotent : detecte si deja patche, skip sinon.
# Re-executer apres toute mise a jour du plugin.

set -e

PLUGIN_VERSION="${PLUGIN_VERSION:-0.0.5}"
PLUGIN_DIR="$HOME/.claude/plugins/cache/claude-plugins-official/telegram/$PLUGIN_VERSION"
SERVER_FILE="$PLUGIN_DIR/server.ts"
MARKER="VOICE_TRANSCRIBE_PATCH"
BACKUP="$SERVER_FILE.orig"

if [ ! -f "$SERVER_FILE" ]; then
  echo "ERROR: Plugin server.ts introuvable: $SERVER_FILE" >&2
  echo "Ajuster PLUGIN_VERSION (actuel: $PLUGIN_VERSION)" >&2
  exit 1
fi

if grep -qF "$MARKER" "$SERVER_FILE"; then
  echo "[skip] Patch deja applique sur $SERVER_FILE"
  exit 0
fi

# Backup original avant patch
[ ! -f "$BACKUP" ] && cp "$SERVER_FILE" "$BACKUP"

# Le patch lui-meme est fait par un script python dedie (regex + insertion)
SERVER_FILE="$SERVER_FILE" python3 "$HOME/octopulse/voice-middleware/patch-voice.py" && SERVER_FILE="$SERVER_FILE" python3 "$HOME/octopulse/voice-middleware/patch-typing.py"

if [ $? -ne 0 ]; then
  echo "[ERROR] patch-voice.py a echoue, restauration backup" >&2
  cp "$BACKUP" "$SERVER_FILE"
  exit 2
fi

# Verif syntaxe rapide via bun build
export PATH="$HOME/.bun/bin:$PATH"
cd "$PLUGIN_DIR"
if command -v bun >/dev/null 2>&1; then
  if ! bun build --target=bun server.ts --outfile=/tmp/tg-check.js >/tmp/bun-err.log 2>&1; then
    echo "[ERROR] Syntaxe cassee apres patch, restauration" >&2
    head -15 /tmp/bun-err.log >&2
    cp "$BACKUP" "$SERVER_FILE"
    exit 3
  fi
  rm -f /tmp/tg-check.js
  echo "[ok] Syntaxe validee par bun build"
else
  echo "[warn] bun absent, skip verif syntaxe"
fi

echo "[ok] Patch applique. Redemarrer la session Claude Code (ou le process plugin) pour charger."
