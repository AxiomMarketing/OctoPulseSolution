#!/bin/bash
# Transcribe audio file via Groq Whisper
# Usage: transcribe.sh <audio_file> [lang]
# Output: transcript on stdout, errors on stderr
# Cache: /run/user/$UID/groq-key (tmpfs, TTL 30 min) pour eviter le cout Bitwarden repete

set -e

AUDIO="$1"
LANG_CODE="${2:-fr}"
BW_ITEM="${GROQ_BW_ITEM:-groq-api-key}"
CACHE_FILE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/groq-key"
CACHE_TTL_SEC="${GROQ_CACHE_TTL:-1800}"  # 30 min

if [ -z "$AUDIO" ] || [ ! -f "$AUDIO" ]; then
  echo "Usage: $0 <audio_file> [lang]" >&2
  exit 1
fi

load_key_from_cache() {
  [ -f "$CACHE_FILE" ] || return 1
  local age
  age=$(( $(date +%s) - $(stat -c%Y "$CACHE_FILE" 2>/dev/null || echo 0) ))
  [ "$age" -gt "$CACHE_TTL_SEC" ] && return 1
  GROQ_API_KEY=$(cat "$CACHE_FILE" 2>/dev/null)
  [ -n "$GROQ_API_KEY" ]
}

fetch_key_from_bitwarden() {
  [ -f "$HOME/.bw-env" ] && source "$HOME/.bw-env" 2>/dev/null || true
  if [ -x "$HOME/bin/bw-ensure-unlock.sh" ]; then
    local new_session
    new_session=$("$HOME/bin/bw-ensure-unlock.sh" 2>/dev/null) || true
    [ -n "$new_session" ] && export BW_SESSION="$new_session"
  fi
  GROQ_API_KEY=$(bw get password "$BW_ITEM" --session "$BW_SESSION" 2>/dev/null || true)
  [ -n "$GROQ_API_KEY" ] || return 1
  # Write cache (tmpfs, 0600)
  if [ -w "$(dirname "$CACHE_FILE")" ]; then
    umask 077
    printf '%s' "$GROQ_API_KEY" > "$CACHE_FILE"
  fi
}

# 1. Env var si deja presente (priorite max)
# 2. Cache tmpfs
# 3. Bitwarden fallback
if [ -z "$GROQ_API_KEY" ]; then
  load_key_from_cache || fetch_key_from_bitwarden || {
    echo "GROQ_API_KEY introuvable (cache: $CACHE_FILE, item BW: $BW_ITEM)" >&2
    exit 2
  }
fi

# Groq whisper rejette .oga, on force un filename reconnu
EXT="${AUDIO##*.}"
case "$EXT" in
  oga) REMOTE_FILENAME="audio.ogg" ;;
  *) REMOTE_FILENAME="audio.$EXT" ;;
esac

START=$(date +%s%N)
RESPONSE=$(curl -sS -X POST \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -F "file=@$AUDIO;filename=$REMOTE_FILENAME" \
  -F "model=whisper-large-v3" \
  -F "response_format=json" \
  -F "language=$LANG_CODE" \
  https://api.groq.com/openai/v1/audio/transcriptions)
END=$(date +%s%N)
LATENCY_MS=$(( (END - START) / 1000000 ))

TEXT=$(echo "$RESPONSE" | jq -r '.text // empty' 2>/dev/null)
ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // empty' 2>/dev/null)

LOG_DIR="$HOME/logs/voice-middleware"
mkdir -p "$LOG_DIR"
SIZE=$(stat -c%s "$AUDIO" 2>/dev/null || echo 0)
CACHE_STATUS="miss"
[ -f "$CACHE_FILE" ] && CACHE_STATUS="hit"

# Si Groq renvoie 401/unauthorized, la cle est peut-etre expiree cote Bitwarden
# ou le cache est stale. On invalide et on retry une fois.
if [ -n "$ERROR_MSG" ] && echo "$ERROR_MSG" | grep -qi 'invalid.*key\|unauthori'; then
  rm -f "$CACHE_FILE"
  unset GROQ_API_KEY
  if fetch_key_from_bitwarden; then
    RESPONSE=$(curl -sS -X POST \
      -H "Authorization: Bearer $GROQ_API_KEY" \
      -F "file=@$AUDIO;filename=$REMOTE_FILENAME" \
      -F "model=whisper-large-v3" \
      -F "response_format=json" \
      -F "language=$LANG_CODE" \
      https://api.groq.com/openai/v1/audio/transcriptions)
    TEXT=$(echo "$RESPONSE" | jq -r '.text // empty' 2>/dev/null)
    ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // empty' 2>/dev/null)
    CACHE_STATUS="refresh"
  fi
fi

if [ -n "$ERROR_MSG" ]; then
  echo "$(date -Iseconds) | ${LATENCY_MS}ms | ${SIZE}B | cache=$CACHE_STATUS | $(basename "$AUDIO") | ERROR: $ERROR_MSG" >> "$LOG_DIR/transcribe.log"
  echo "Groq error: $ERROR_MSG" >&2
  exit 3
fi

echo "$(date -Iseconds) | ${LATENCY_MS}ms | ${SIZE}B | cache=$CACHE_STATUS | $(basename "$AUDIO") | ${TEXT:0:120}" >> "$LOG_DIR/transcribe.log"

if [ -z "$TEXT" ]; then
  echo "Transcription vide (Groq n'a detecte aucune parole)" >&2
  exit 4
fi

echo "$TEXT"
