#!/bin/bash
# get-products.sh — List Shopify products with title, status, and variant count
# Usage: ./get-products.sh [--dry-run] [--limit N] [--status active|draft|archived]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${SCRIPT_DIR}/../../_lib"
STORE="rungraphik.myshopify.com"
API_VERSION="2026-04"
BASE_URL="https://${STORE}/admin/api/${API_VERSION}"

DRY_RUN=false
LIMIT=50
STATUS="active"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --limit) LIMIT="$2"; shift ;;
    --status) STATUS="$2"; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call:"
  echo "  GET ${BASE_URL}/products.json?limit=${LIMIT}&status=${STATUS}&fields=id,title,status,variants"
  echo ""
  echo "  Auth: X-Shopify-Access-Token: <from bw: shopify-access-token>"
  exit 0
fi

TOKEN=$("${LIB}/bw-get.sh" shopify-access-token)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "X-Shopify-Access-Token: ${TOKEN}" \
  "${BASE_URL}/products.json?limit=${LIMIT}&status=${STATUS}&fields=id,title,status,variants")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" != "200" ]; then
  echo "ERROR: HTTP ${HTTP_CODE}" >&2
  echo "$BODY" >&2
  exit 1
fi

echo "$BODY" | python3 -c "
import json, sys
data = json.load(sys.stdin)
products = data.get('products', [])
print(f'Products: {len(products)} (limit=${LIMIT}, status=${STATUS})')
print(f'{\"ID\":<15} {\"STATUS\":<10} {\"VARIANTS\":<10} TITLE')
print('-' * 70)
for p in products:
    vcount = len(p.get('variants', []))
    print(f'{p[\"id\"]:<15} {p[\"status\"]:<10} {vcount:<10} {p[\"title\"][:40]}')
"
