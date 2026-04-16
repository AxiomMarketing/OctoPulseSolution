#!/bin/bash
# get-events.sh — Fetch recent PostHog events
# Usage: ./get-events.sh [--dry-run] [--project-id ID] [--event NAME] [--limit N] [--after DATETIME]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
PROJECT_ID="${POSTHOG_PROJECT_ID:-}"
EVENT_NAME=""
LIMIT=100
AFTER=""
BASE_URL="${POSTHOG_BASE_URL:-https://app.posthog.com}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)    DRY_RUN=true ;;
    --project-id) PROJECT_ID="$2"; shift ;;
    --event)      EVENT_NAME="$2"; shift ;;
    --limit)      LIMIT="$2"; shift ;;
    --after)      AFTER="$2"; shift ;;
    --base-url)   BASE_URL="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

ENDPOINT="/api/projects/${PROJECT_ID}/events"
QUERY="limit=${LIMIT}"
[ -n "$EVENT_NAME" ] && QUERY="${QUERY}&event=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$EVENT_NAME")"
[ -n "$AFTER" ]      && QUERY="${QUERY}&after=${AFTER}"

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call: GET ${BASE_URL}/api/projects/<project_id>/events?${QUERY}"
  echo "[DRY-RUN] Headers: Authorization: Bearer <bw:posthog-api-key>"
  echo "[DRY-RUN] Project ID: ${PROJECT_ID:-<check bw:posthog-api-key notes>}"
  [ -n "$EVENT_NAME" ] && echo "[DRY-RUN] Filtering event: ${EVENT_NAME}"
  exit 0
fi

if [ -z "$PROJECT_ID" ]; then
  echo "ERROR: PROJECT_ID required. Pass --project-id or set POSTHOG_PROJECT_ID env var." >&2
  echo "Check: bw get item posthog-api-key (notes field)" >&2
  exit 1
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "posthog-api-key")
START=$(date +%s%3N)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Bearer ${TOKEN}" \
  "${BASE_URL}${ENDPOINT}?${QUERY}")

STATUS_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
END=$(date +%s%3N)
LATENCY=$(( END - START ))
SIZE=${#BODY}

"$LIB_DIR/log-api-call.sh" "posthog" "get-events" "GET" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
