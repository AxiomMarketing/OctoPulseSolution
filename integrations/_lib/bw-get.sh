#!/bin/bash
# Usage: bw-get.sh <bitwarden-item-name>
# Output: key value on stdout
# Cache: /run/user/$UID/api-key-<item> (tmpfs, TTL 30min)
set -e
ITEM="$1"
[ -z "$ITEM" ] && { echo "Usage: bw-get.sh <item>" >&2; exit 1; }
CACHE_FILE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/api-key-$(echo "$ITEM" | tr ' ' '-')"
CACHE_TTL=1800

# Try cache first
if [ -f "$CACHE_FILE" ]; then
  AGE=$(( $(date +%s) - $(stat -c%Y "$CACHE_FILE" 2>/dev/null || echo 0) ))
  if [ "$AGE" -le "$CACHE_TTL" ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# Fetch from Bitwarden
[ -f "$HOME/.bw-env" ] && source "$HOME/.bw-env" 2>/dev/null || true
if [ -x "$HOME/bin/bw-ensure-unlock.sh" ]; then
  NEW_SESSION=$("$HOME/bin/bw-ensure-unlock.sh" 2>/dev/null) || true
  [ -n "$NEW_SESSION" ] && export BW_SESSION="$NEW_SESSION"
fi
KEY=$(bw get password "$ITEM" --session "$BW_SESSION" 2>/dev/null || true)
[ -z "$KEY" ] && { echo "ERROR: key '$ITEM' not found in Bitwarden" >&2; exit 2; }

# Write cache
if [ -w "$(dirname "$CACHE_FILE")" ]; then
  umask 077; printf '%s' "$KEY" > "$CACHE_FILE"
fi
printf '%s' "$KEY"
