#!/bin/bash
# Recipe: get-campaign-insights-24h.sh
# Description: Fetch yesterday's performance metrics at campaign level
# Usage: ./get-campaign-insights-24h.sh [--dry-run] [act_XXXXXXXXX]

set -euo pipefail

INTEGRATION_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LIB_DIR="$INTEGRATION_DIR/_lib"

AD_ACCOUNT_ID="act_XXXXXXXXX"

# Parse args
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    act_*) AD_ACCOUNT_ID="$arg" ;;
  esac
done

FIELDS="spend,impressions,clicks,ctr,cpm,reach,frequency,actions,action_values,purchase_roas,cost_per_action_type"
BASE_URL="https://graph.facebook.com/v21.0"
ENDPOINT="/$AD_ACCOUNT_ID/insights"
PARAMS="fields=$FIELDS&date_preset=yesterday&level=campaign&limit=100"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "curl -s '$BASE_URL$ENDPOINT?$PARAMS' -H 'Authorization: Bearer <TOKEN>'"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" meta-long-token)

START_TS=$(date +%s%3N)
RESULT=$(curl -s "$BASE_URL$ENDPOINT?$PARAMS" \
  -H "Authorization: Bearer $TOKEN")
END_TS=$(date +%s%3N)
LATENCY=$(( END_TS - START_TS ))

STATUS=$(echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',{}).get('code',200))" 2>/dev/null || echo 200)
SIZE=$(echo "$RESULT" | wc -c)

echo "$RESULT" | python3 -m json.tool 2>/dev/null || echo "$RESULT"

"$LIB_DIR/log-api-call.sh" meta-ads atlas GET "$ENDPOINT" "$STATUS" "$LATENCY" "$SIZE"
