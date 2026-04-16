#!/bin/bash
# create-event.sh — Create a Klaviyo tracking event
# Usage: ./create-event.sh [--dry-run] [--email EMAIL] [--event EVENT_NAME] [--order-id ID] [--total AMOUNT]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
EMAIL="test@example.com"
EVENT_NAME="Placed Order"
ORDER_ID="test-order-001"
TOTAL="59.99"
CURRENCY="EUR"
REVISION="2024-10-15"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)  DRY_RUN=true ;;
    --email)    EMAIL="$2"; shift ;;
    --event)    EVENT_NAME="$2"; shift ;;
    --order-id) ORDER_ID="$2"; shift ;;
    --total)    TOTAL="$2"; shift ;;
    --currency) CURRENCY="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

BASE_URL="https://a.klaviyo.com/api"
ENDPOINT="/events"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
UNIQUE_ID="${ORDER_ID}-placed-$(date +%s)"

PAYLOAD=$(cat <<EOF
{
  "data": {
    "type": "event",
    "attributes": {
      "profile": {
        "data": {
          "type": "profile",
          "attributes": {
            "email": "${EMAIL}"
          }
        }
      },
      "metric": {
        "data": {
          "type": "metric",
          "attributes": {
            "name": "${EVENT_NAME}"
          }
        }
      },
      "properties": {
        "order_id": "${ORDER_ID}",
        "total": ${TOTAL},
        "currency": "${CURRENCY}"
      },
      "time": "${TIMESTAMP}",
      "unique_id": "${UNIQUE_ID}"
    }
  }
}
EOF
)

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call: POST ${BASE_URL}${ENDPOINT}"
  echo "[DRY-RUN] Headers: Authorization: Klaviyo-API-Key <bw:klaviyo-api-key>"
  echo "[DRY-RUN] Headers: revision: ${REVISION}"
  echo "[DRY-RUN] Payload:"
  echo "$PAYLOAD" | python3 -m json.tool 2>/dev/null || echo "$PAYLOAD"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "klaviyo-api-key")
START=$(date +%s%3N)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Authorization: Klaviyo-API-Key ${TOKEN}" \
  -H "revision: ${REVISION}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "${BASE_URL}${ENDPOINT}")

STATUS_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
END=$(date +%s%3N)
LATENCY=$(( END - START ))
SIZE=${#BODY}

"$LIB_DIR/log-api-call.sh" "klaviyo" "create-event" "POST" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

if [ "$STATUS_CODE" = "202" ] || [ "$STATUS_CODE" = "200" ]; then
  echo "Event created successfully (HTTP ${STATUS_CODE})"
  [ -n "$BODY" ] && echo "$BODY" | python3 -m json.tool 2>/dev/null || true
else
  echo "Error (HTTP ${STATUS_CODE}):"
  echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
  exit 1
fi
