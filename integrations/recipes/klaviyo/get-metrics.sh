#!/bin/bash
# get-metrics.sh — List Klaviyo metrics
# Usage: ./get-metrics.sh [--dry-run] [--limit N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
PAGE_SIZE=50
REVISION="2024-10-15"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)  DRY_RUN=true ;;
    --limit)    PAGE_SIZE="$2"; shift ;;
    --revision) REVISION="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

BASE_URL="https://a.klaviyo.com/api"
ENDPOINT="/metrics"

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call: GET ${BASE_URL}${ENDPOINT}?page[size]=${PAGE_SIZE}"
  echo "[DRY-RUN] Headers: Authorization: Klaviyo-API-Key <bw:klaviyo-api-key>"
  echo "[DRY-RUN] Headers: revision: ${REVISION}"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "klaviyo-api-key")
START=$(date +%s%3N)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Klaviyo-API-Key ${TOKEN}" \
  -H "revision: ${REVISION}" \
  "${BASE_URL}${ENDPOINT}?page%5Bsize%5D=${PAGE_SIZE}")

STATUS_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
END=$(date +%s%3N)
LATENCY=$(( END - START ))
SIZE=${#BODY}

"$LIB_DIR/log-api-call.sh" "klaviyo" "get-metrics" "GET" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
