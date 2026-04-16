#!/bin/bash
# Recipe: get-all-active-campaigns.sh
# Description: Fetch all active and paused campaigns with budget info
# Usage: ./get-all-active-campaigns.sh [--dry-run] [act_XXXXXXXXX]

set -euo pipefail

INTEGRATION_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LIB_DIR="$INTEGRATION_DIR/_lib"

AD_ACCOUNT_ID="act_XXXXXXXXX"

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    act_*) AD_ACCOUNT_ID="$arg" ;;
  esac
done

FIELDS="id,name,status,effective_status,objective,bid_strategy,daily_budget,lifetime_budget,buying_type,start_time,stop_time,created_time,updated_time"
STATUSES='["ACTIVE","PAUSED"]'
BASE_URL="https://graph.facebook.com/v21.0"
ENDPOINT="/$AD_ACCOUNT_ID/campaigns"
PARAMS="fields=$FIELDS&effective_status=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${STATUSES}'))")&limit=200"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "curl -s '$BASE_URL$ENDPOINT' -G \\"
  echo "  --data-urlencode 'fields=$FIELDS' \\"
  echo "  --data-urlencode 'effective_status=${STATUSES}' \\"
  echo "  --data-urlencode 'limit=200' \\"
  echo "  -H 'Authorization: Bearer <TOKEN>'"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" meta-long-token)

START_TS=$(date +%s%3N)
RESULT=$(curl -s "$BASE_URL$ENDPOINT" \
  -G \
  --data-urlencode "fields=$FIELDS" \
  --data-urlencode "effective_status=${STATUSES}" \
  --data-urlencode "limit=200" \
  -H "Authorization: Bearer $TOKEN")
END_TS=$(date +%s%3N)
LATENCY=$(( END_TS - START_TS ))

STATUS=$(echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',{}).get('code',200))" 2>/dev/null || echo 200)
SIZE=$(echo "$RESULT" | wc -c)

echo "$RESULT" | python3 -m json.tool 2>/dev/null || echo "$RESULT"

"$LIB_DIR/log-api-call.sh" meta-ads atlas GET "$ENDPOINT" "$STATUS" "$LATENCY" "$SIZE"
