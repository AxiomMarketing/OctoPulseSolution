#!/bin/bash
# query-insights.sh — Query PostHog via HogQL
# Usage: ./query-insights.sh [--dry-run] [--project-id ID] [--sql "SELECT ..."] [--days N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../../_lib"

DRY_RUN=false
PROJECT_ID="${POSTHOG_PROJECT_ID:-}"
DAYS=7
SQL_QUERY=""
BASE_URL="${POSTHOG_BASE_URL:-https://app.posthog.com}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)    DRY_RUN=true ;;
    --project-id) PROJECT_ID="$2"; shift ;;
    --sql)        SQL_QUERY="$2"; shift ;;
    --days)       DAYS="$2"; shift ;;
    --base-url)   BASE_URL="$2"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

# Default query if none provided
if [ -z "$SQL_QUERY" ]; then
  SQL_QUERY="SELECT event, count() as cnt FROM events WHERE timestamp > now() - interval ${DAYS} day GROUP BY event ORDER BY cnt DESC LIMIT 20"
fi

ENDPOINT="/api/projects/${PROJECT_ID}/query"

PAYLOAD=$(cat <<EOF
{
  "query": {
    "kind": "HogQLQuery",
    "query": $(python3 -c "import json,sys; print(json.dumps(sys.argv[1]))" "$SQL_QUERY")
  }
}
EOF
)

if [ "$DRY_RUN" = true ]; then
  echo "[DRY-RUN] Would call: POST ${BASE_URL}${ENDPOINT}"
  echo "[DRY-RUN] Headers: Authorization: Bearer <bw:posthog-api-key>"
  echo "[DRY-RUN] Payload:"
  echo "$PAYLOAD" | python3 -m json.tool 2>/dev/null || echo "$PAYLOAD"
  echo ""
  echo "[DRY-RUN] Project ID: ${PROJECT_ID:-<check bw:posthog-api-key notes>}"
  exit 0
fi

if [ -z "$PROJECT_ID" ]; then
  echo "ERROR: PROJECT_ID required. Pass --project-id or set POSTHOG_PROJECT_ID env var." >&2
  echo "Check: bw get item posthog-api-key (notes field)" >&2
  exit 1
fi

TOKEN=$("$LIB_DIR/bw-get.sh" "posthog-api-key")
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

"$LIB_DIR/log-api-call.sh" "posthog" "query-insights" "POST" "${ENDPOINT}" "$STATUS_CODE" "$LATENCY" "$SIZE"

echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
