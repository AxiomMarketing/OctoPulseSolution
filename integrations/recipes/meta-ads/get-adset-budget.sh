#!/bin/bash
# Recipe: get-adset-budget.sh
# Description: Fetch all ad sets with budget, bidding, and delivery status
# Usage: ./get-adset-budget.sh [--dry-run] [act_XXXXXXXXX] [campaign_id]

set -euo pipefail

INTEGRATION_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LIB_DIR="$INTEGRATION_DIR/_lib"

AD_ACCOUNT_ID="act_XXXXXXXXX"
CAMPAIGN_ID=""

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    act_*) AD_ACCOUNT_ID="$arg" ;;
    [0-9]*) CAMPAIGN_ID="$arg" ;;
  esac
done

FIELDS="id,name,campaign_id,status,effective_status,daily_budget,lifetime_budget,budget_remaining,bid_amount,bid_strategy,billing_event,optimization_goal,start_time,end_time,created_time"

BASE_URL="https://graph.facebook.com/v21.0"
ENDPOINT="/$AD_ACCOUNT_ID/adsets"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "curl -s '$BASE_URL$ENDPOINT' -G \\"
  echo "  --data-urlencode 'fields=$FIELDS' \\"
  [ -n "$CAMPAIGN_ID" ] && echo "  --data-urlencode 'effective_status=[\"ACTIVE\",\"PAUSED\"]' \\" || true
  [ -n "$CAMPAIGN_ID" ] && echo "  --data-urlencode 'filtering=[{\"field\":\"campaign_id\",\"operator\":\"EQUAL\",\"value\":\"$CAMPAIGN_ID\"}]' \\" || true
  echo "  --data-urlencode 'limit=200' \\"
  echo "  -H 'Authorization: Bearer <TOKEN>'"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" meta-long-token)

# Build curl args
CURL_ARGS=(
  -s "$BASE_URL$ENDPOINT"
  -G
  --data-urlencode "fields=$FIELDS"
  --data-urlencode "effective_status=[\"ACTIVE\",\"PAUSED\"]"
  --data-urlencode "limit=200"
  -H "Authorization: Bearer $TOKEN"
)

if [ -n "$CAMPAIGN_ID" ]; then
  CURL_ARGS+=(--data-urlencode "filtering=[{\"field\":\"campaign_id\",\"operator\":\"EQUAL\",\"value\":\"$CAMPAIGN_ID\"}]")
fi

START_TS=$(date +%s%3N)
RESULT=$(curl "${CURL_ARGS[@]}")
END_TS=$(date +%s%3N)
LATENCY=$(( END_TS - START_TS ))

STATUS=$(echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',{}).get('code',200))" 2>/dev/null || echo 200)
SIZE=$(echo "$RESULT" | wc -c)

echo "$RESULT" | python3 -m json.tool 2>/dev/null || echo "$RESULT"

"$LIB_DIR/log-api-call.sh" meta-ads atlas GET "$ENDPOINT" "$STATUS" "$LATENCY" "$SIZE"
