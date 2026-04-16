#!/bin/bash
# Recipe: get-ad-performance.sh
# Description: Fetch ad-level performance for last 7 days (spend, CTR, ROAS)
# Usage: ./get-ad-performance.sh [--dry-run] [act_XXXXXXXXX] [date_preset]

set -euo pipefail

INTEGRATION_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LIB_DIR="$INTEGRATION_DIR/_lib"

AD_ACCOUNT_ID="act_XXXXXXXXX"
DATE_PRESET="last_7d"

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    act_*) AD_ACCOUNT_ID="$arg" ;;
    last_*|yesterday|this_*) DATE_PRESET="$arg" ;;
  esac
done

FIELDS="spend,impressions,clicks,ctr,cpm,cpc,reach,actions,action_values,purchase_roas,cost_per_action_type,ad_id,ad_name,adset_id,adset_name,campaign_id,campaign_name"
BASE_URL="https://graph.facebook.com/v21.0"
ENDPOINT="/$AD_ACCOUNT_ID/insights"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "curl -s '$BASE_URL$ENDPOINT' -G \\"
  echo "  --data-urlencode 'fields=$FIELDS' \\"
  echo "  --data-urlencode 'date_preset=$DATE_PRESET' \\"
  echo "  --data-urlencode 'level=ad' \\"
  echo "  --data-urlencode 'sort=spend_descending' \\"
  echo "  --data-urlencode 'limit=100' \\"
  echo "  -H 'Authorization: Bearer <TOKEN>'"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" meta-long-token)

START_TS=$(date +%s%3N)
RESULT=$(curl -s "$BASE_URL$ENDPOINT" \
  -G \
  --data-urlencode "fields=$FIELDS" \
  --data-urlencode "date_preset=$DATE_PRESET" \
  --data-urlencode "level=ad" \
  --data-urlencode "sort=spend_descending" \
  --data-urlencode "limit=100" \
  -H "Authorization: Bearer $TOKEN")
END_TS=$(date +%s%3N)
LATENCY=$(( END_TS - START_TS ))

STATUS=$(echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',{}).get('code',200))" 2>/dev/null || echo 200)
SIZE=$(echo "$RESULT" | wc -c)

echo "$RESULT" | python3 -m json.tool 2>/dev/null || echo "$RESULT"

"$LIB_DIR/log-api-call.sh" meta-ads atlas GET "$ENDPOINT" "$STATUS" "$LATENCY" "$SIZE"
