#!/bin/bash
# list-orders.sh — List Printful orders
# Usage: ./list-orders.sh [--dry-run] [--status STATUS] [--limit N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
STATUS=""
LIMIT=20
OFFSET=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --status)  STATUS="$2"; shift ;;
    --limit)   LIMIT="$2";  shift ;;
    --offset)  OFFSET="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

BASE_URL="https://api.printful.com"
ENDPOINT="/orders"

# Build query string
QUERY="limit=${LIMIT}&offset=${OFFSET}"
[ -n "$STATUS" ] && QUERY="${QUERY}&status=${STATUS}"

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call: GET ${BASE_URL}${ENDPOINT}?${QUERY}"
  echo "[DRY-RUN] Headers: Authorization: Bearer <bw:Printful>"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "Printful")
START=$(date +%s%3N)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Bearer ${TOKEN}" \
  "${BASE_URL}${ENDPOINT}?${QUERY}")

STATUS_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
END=$(date +%s%3N)
LATENCY=$(( END - START ))
SIZE=${#BODY}

"$LIB_DIR/log-api-call.sh" "printful" "list-orders" "GET" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
