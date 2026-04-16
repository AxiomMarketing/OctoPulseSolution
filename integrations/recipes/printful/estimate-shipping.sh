#!/bin/bash
# estimate-shipping.sh — Estimate Printful shipping rates
# Usage: ./estimate-shipping.sh [--dry-run] [--country FR] [--zip 75001] [--variant-id N] [--qty N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
COUNTRY_CODE="FR"
ZIP="75001"
CITY="Paris"
VARIANT_ID=""
QTY=1
CURRENCY="EUR"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)    DRY_RUN=true ;;
    --country)    COUNTRY_CODE="$2"; shift ;;
    --zip)        ZIP="$2"; shift ;;
    --city)       CITY="$2"; shift ;;
    --variant-id) VARIANT_ID="$2"; shift ;;
    --qty)        QTY="$2"; shift ;;
    --currency)   CURRENCY="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

BASE_URL="https://api.printful.com"
ENDPOINT="/shipping/rates"

# Build items array
if [ -z "$VARIANT_ID" ]; then
  # Use a real Printful poster variant ID as example (Framed Poster 21x30cm)
  VARIANT_ID=4012
fi

PAYLOAD=$(cat <<EOF
{
  "recipient": {
    "address1": "1 Rue Example",
    "city": "${CITY}",
    "country_code": "${COUNTRY_CODE}",
    "zip": "${ZIP}"
  },
  "items": [
    {
      "variant_id": ${VARIANT_ID},
      "quantity": ${QTY},
      "value": "29.99"
    }
  ],
  "currency": "${CURRENCY}"
}
EOF
)

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call: POST ${BASE_URL}${ENDPOINT}"
  echo "[DRY-RUN] Headers: Authorization: Bearer <bw:Printful>"
  echo "[DRY-RUN] Payload:"
  echo "$PAYLOAD" | python3 -m json.tool 2>/dev/null || echo "$PAYLOAD"
  exit 0
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "Printful")
START=$(date +%s%3N)

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "${BASE_URL}${ENDPOINT}")

STATUS_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | head -n -1)
END=$(date +%s%3N)
LATENCY=$(( END - START ))
SIZE=${#BODY}

"$LIB_DIR/log-api-call.sh" "printful" "estimate-shipping" "POST" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
