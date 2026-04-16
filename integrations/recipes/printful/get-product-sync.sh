#!/bin/bash
# get-product-sync.sh — List or get Printful sync products
# Usage: ./get-product-sync.sh [--dry-run] [--id PRODUCT_ID] [--limit N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
PRODUCT_ID=""
LIMIT=20

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --id)      PRODUCT_ID="$2"; shift ;;
    --limit)   LIMIT="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

BASE_URL="https://api.printful.com"

if [ -n "$PRODUCT_ID" ]; then
  ENDPOINT="/sync/products/${PRODUCT_ID}"
  QUERY=""
else
  ENDPOINT="/sync/products"
  QUERY="limit=${LIMIT}"
fi

if [ "$DRY_RUN" = true ]; then
  if [ -n "$PRODUCT_ID" ]; then
    echo "[DRY-RUN] Would call: GET ${BASE_URL}${ENDPOINT}"
  else
    echo "[DRY-RUN] Would call: GET ${BASE_URL}${ENDPOINT}?${QUERY}"
  fi
  echo "[DRY-RUN] Headers: Authorization: Bearer <bw:Printful>"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "Printful")
START=$(date +%s%3N)

URL="${BASE_URL}${ENDPOINT}"
[ -n "$QUERY" ] && URL="${URL}?${QUERY}"

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: Bearer ${TOKEN}" \
  "$URL")

STATUS_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
END=$(date +%s%3N)
LATENCY=$(( END - START ))
SIZE=${#BODY}

"$LIB_DIR/log-api-call.sh" "printful" "get-product-sync" "GET" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
