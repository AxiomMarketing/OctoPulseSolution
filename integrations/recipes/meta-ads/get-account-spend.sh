#!/bin/bash
# Recipe: get-account-spend.sh
# Description: Fetch total account-level spend for a given period (default: this month)
# Usage: ./get-account-spend.sh [--dry-run] [act_XXXXXXXXX] [date_preset]

set -euo pipefail

INTEGRATION_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LIB_DIR="$INTEGRATION_DIR/_lib"

AD_ACCOUNT_ID="act_XXXXXXXXX"
DATE_PRESET="this_month"

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    act_*) AD_ACCOUNT_ID="$arg" ;;
    last_*|yesterday|this_*|today) DATE_PRESET="$arg" ;;
  esac
done

FIELDS="spend,impressions,clicks,ctr,cpm,reach,actions,purchase_roas,date_start,date_stop,account_id,account_name"
BASE_URL="https://graph.facebook.com/v21.0"
ENDPOINT="/$AD_ACCOUNT_ID/insights"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "curl -s '$BASE_URL$ENDPOINT' -G \\"
  echo "  --data-urlencode 'fields=$FIELDS' \\"
  echo "  --data-urlencode 'date_preset=$DATE_PRESET' \\"
  echo "  --data-urlencode 'level=account' \\"
  echo "  -H 'Authorization: Bearer <TOKEN>'"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" meta-long-token)

START_TS=$(date +%s%3N)
RESULT=$(curl -s "$BASE_URL$ENDPOINT" \
  -G \
  --data-urlencode "fields=$FIELDS" \
  --data-urlencode "date_preset=$DATE_PRESET" \
  --data-urlencode "level=account" \
  -H "Authorization: Bearer $TOKEN")
END_TS=$(date +%s%3N)
LATENCY=$(( END_TS - START_TS ))

STATUS=$(echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',{}).get('code',200))" 2>/dev/null || echo 200)
SIZE=$(echo "$RESULT" | wc -c)

# Pretty print with summary
echo "$RESULT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'error' in d:
    print('ERROR:', json.dumps(d['error'], indent=2))
    sys.exit(1)
data = d.get('data', [])
if data:
    r = data[0]
    print('=== Account Spend Summary ===')
    print(f\"Period  : {r.get('date_start')} → {r.get('date_stop')}\")
    print(f\"Spend   : {r.get('spend')} \")
    print(f\"Impress.: {r.get('impressions')}\")
    print(f\"Clicks  : {r.get('clicks')}\")
    print(f\"CTR     : {r.get('ctr')}%\")
    print(f\"CPM     : {r.get('cpm')}\")
    roas = r.get('purchase_roas', [])
    if roas:
        print(f\"ROAS    : {roas[0].get('value','N/A')}\")
    print()
print(json.dumps(d, indent=2))
" 2>/dev/null || echo "$RESULT"

"$LIB_DIR/log-api-call.sh" meta-ads atlas GET "$ENDPOINT" "$STATUS" "$LATENCY" "$SIZE"
