#!/bin/bash
# get-orders-24h.sh — List Shopify orders from the last 24 hours
# Usage: ./get-orders-24h.sh [--dry-run] [--hours N] [--status any|open|closed]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${SCRIPT_DIR}/../../_lib"
STORE="rungraphik.myshopify.com"
API_VERSION="2026-04"
BASE_URL="https://${STORE}/admin/api/${API_VERSION}"

DRY_RUN=false
HOURS=24
STATUS="any"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --hours) HOURS="$2"; shift ;;
    --status) STATUS="$2"; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

# Cross-platform ISO8601 date (Linux + macOS)
if date --version 2>/dev/null | grep -q GNU; then
  SINCE=$(date -u -d "${HOURS} hours ago" +"%Y-%m-%dT%H:%M:%SZ")
else
  SINCE=$(date -u -v-${HOURS}H +"%Y-%m-%dT%H:%M:%SZ")
fi

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call:"
  echo "  GET ${BASE_URL}/orders.json?status=${STATUS}&created_at_min=${SINCE}&limit=50"
  echo "  Fields: id,order_number,email,total_price,currency,financial_status,fulfillment_status,created_at,line_items"
  echo ""
  echo "  Auth: X-Shopify-Access-Token: <from bw: shopify-access-token>"
  exit 0
fi

TOKEN=$("${LIB}/bw-get.sh" shopify-access-token)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "X-Shopify-Access-Token: ${TOKEN}" \
  "${BASE_URL}/orders.json?status=${STATUS}&created_at_min=${SINCE}&limit=50&fields=id,order_number,email,total_price,currency,financial_status,fulfillment_status,created_at,line_items")

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
orders = data.get('orders', [])
print(f'Orders last ${HOURS}h: {len(orders)}')
total_revenue = sum(float(o.get('total_price','0')) for o in orders)
print(f'Total revenue: {total_revenue:.2f}')
print()
print(f'{\"Order#\":<10} {\"Financial\":<14} {\"Fulfillment\":<14} {\"Total\":<10} EMAIL')
print('-' * 75)
for o in orders:
    print(f'{o[\"order_number\"]:<10} {o.get(\"financial_status\",\"\"):<14} {str(o.get(\"fulfillment_status\",\"unfulfilled\")):<14} {o[\"total_price\"]:<10} {o.get(\"email\",\"N/A\")[:30]}')
"
