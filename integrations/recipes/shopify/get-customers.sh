#!/bin/bash
# get-customers.sh — List Shopify customers with email and order count
# Usage: ./get-customers.sh [--dry-run] [--limit N] [--search QUERY]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${SCRIPT_DIR}/../../_lib"
STORE="rungraphik.myshopify.com"
API_VERSION="2026-04"
BASE_URL="https://${STORE}/admin/api/${API_VERSION}"

DRY_RUN=false
LIMIT=50
SEARCH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --limit) LIMIT="$2"; shift ;;
    --search) SEARCH="$2"; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

if [ "$DRY_RUN" = true ]; then
  if [ -n "$SEARCH" ]; then
    echo "[DRY-RUN] Would call:"
    echo "  GET ${BASE_URL}/customers/search.json?query=${SEARCH}&limit=${LIMIT}"
  else
    echo "[DRY-RUN] Would call:"
    echo "  GET ${BASE_URL}/customers.json?limit=${LIMIT}&fields=id,email,first_name,last_name,orders_count,total_spent,created_at"
  fi
  echo ""
  echo "  Auth: X-Shopify-Access-Token: <from bw: shopify-access-token>"
  exit 0
fi

TOKEN=$("${LIB}/bw-get.sh" shopify-access-token)

if [ -n "$SEARCH" ]; then
  ENCODED_SEARCH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${SEARCH}'))")
  ENDPOINT="${BASE_URL}/customers/search.json?query=${ENCODED_SEARCH}&limit=${LIMIT}"
else
  ENDPOINT="${BASE_URL}/customers.json?limit=${LIMIT}&fields=id,email,first_name,last_name,orders_count,total_spent,created_at"
fi

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -H "X-Shopify-Access-Token: ${TOKEN}" \
  "$ENDPOINT")

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
customers = data.get('customers', [])
print(f'Customers: {len(customers)} (limit=${LIMIT})')
print()
print(f'{\"ID\":<15} {\"ORDERS\":<8} {\"SPENT\":<10} {\"NAME\":<25} EMAIL')
print('-' * 80)
for c in customers:
    name = f'{c.get(\"first_name\",\"\")} {c.get(\"last_name\",\"\")}'.strip()
    print(f'{c[\"id\"]:<15} {c.get(\"orders_count\",0):<8} {str(c.get(\"total_spent\",\"0.00\")):<10} {name[:24]:<25} {c.get(\"email\",\"N/A\")[:30]}')
"
