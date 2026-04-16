#!/bin/bash
# list-flows.sh — List Klaviyo flows
# Usage: ./list-flows.sh [--dry-run] [--status live|draft|manual] [--limit N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
STATUS_FILTER=""
PAGE_SIZE=50
REVISION="2024-10-15"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)  DRY_RUN=true ;;
    --status)   STATUS_FILTER="$2"; shift ;;
    --limit)    PAGE_SIZE="$2"; shift ;;
    --revision) REVISION="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

BASE_URL="https://a.klaviyo.com/api"
ENDPOINT="/flows"

QUERY="page[size]=${PAGE_SIZE}"
[ -n "$STATUS_FILTER" ] && QUERY="${QUERY}&filter=equals(status,\"${STATUS_FILTER}\")"

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call: GET ${BASE_URL}${ENDPOINT}?${QUERY}"
  echo "[DRY-RUN] Headers: Authorization: Klaviyo-API-Key <bw:klaviyo-api-key>"
  echo "[DRY-RUN] Headers: revision: ${REVISION}"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "klaviyo-api-key")
START=$(date +%s%3N)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Klaviyo-API-Key ${TOKEN}" \
  -H "revision: ${REVISION}" \
  -G --data-urlencode "page[size]=${PAGE_SIZE}" \
  $([ -n "$STATUS_FILTER" ] && echo "--data-urlencode filter=equals(status,\"${STATUS_FILTER}\")") \
  "${BASE_URL}${ENDPOINT}")

STATUS_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
END=$(date +%s%3N)
LATENCY=$(( END - START ))
SIZE=${#BODY}

"$LIB_DIR/log-api-call.sh" "klaviyo" "list-flows" "GET" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
