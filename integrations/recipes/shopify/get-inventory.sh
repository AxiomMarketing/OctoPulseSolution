#!/bin/bash
# get-inventory.sh — List Shopify inventory levels across all locations
# Usage: ./get-inventory.sh [--dry-run] [--location-id ID] [--low-stock N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${SCRIPT_DIR}/../../_lib"
STORE="rungraphik.myshopify.com"
API_VERSION="2026-04"
BASE_URL="https://${STORE}/admin/api/${API_VERSION}"

DRY_RUN=false
LOCATION_ID=""
LOW_STOCK=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --location-id) LOCATION_ID="$2"; shift ;;
    --low-stock) LOW_STOCK="$2"; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call:"
  echo "  Step 1: GET ${BASE_URL}/locations.json"
  echo "  Step 2: GET ${BASE_URL}/inventory_levels.json?location_ids=<location_id>&limit=250"
  echo "  Step 3: GET ${BASE_URL}/inventory_items/<ids>.json (for SKUs)"
  echo ""
  echo "  Auth: X-Shopify-Access-Token: <from bw: shopify-access-token>"
  if [ -n "$LOW_STOCK" ]; then
    echo "  Filter: available <= ${LOW_STOCK}"
  fi
  exit 0
fi

TOKEN=$("${LIB}/bw-get.sh" shopify-access-token)

# Get locations if not specified
if [ -z "$LOCATION_ID" ]; then
  LOCS=$(curl -s -H "X-Shopify-Access-Token: ${TOKEN}" "${BASE_URL}/locations.json")
  LOCATION_ID=$(echo "$LOCS" | python3 -c "
import json,sys
locs=json.load(sys.stdin)['locations']
active=[l for l in locs if l.get('active')]
if active:
    print(active[0]['id'])
" 2>/dev/null)
  LOC_NAME=$(echo "$LOCS" | python3 -c "
import json,sys
locs=json.load(sys.stdin)['locations']
active=[l for l in locs if l.get('active')]
if active:
    print(active[0]['name'])
" 2>/dev/null)
  echo "Using location: ${LOC_NAME} (${LOCATION_ID})"
fi

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "X-Shopify-Access-Token: ${TOKEN}" \
  "${BASE_URL}/inventory_levels.json?location_ids=${LOCATION_ID}&limit=250")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" != "200" ]; then
  echo "ERROR: HTTP ${HTTP_CODE}" >&2
  echo "$BODY" >&2
  exit 1
fi

LOW_STOCK_FILTER="${LOW_STOCK}"
echo "$BODY" | python3 -c "
import json, sys
data = json.load(sys.stdin)
levels = data.get('inventory_levels', [])
low_stock = '${LOW_STOCK_FILTER}'

if low_stock:
    levels = [l for l in levels if l.get('available', 0) <= int(low_stock)]
    print(f'Low stock items (available <= {low_stock}): {len(levels)}')
else:
    print(f'Inventory levels: {len(levels)}')

print()
print(f'{\"ITEM_ID\":<15} {\"AVAILABLE\":<12} UPDATED')
print('-' * 50)
for l in sorted(levels, key=lambda x: x.get('available', 0)):
    print(f'{l[\"inventory_item_id\"]:<15} {l.get(\"available\",0):<12} {l.get(\"updated_at\",\"\")[:10]}')
"
