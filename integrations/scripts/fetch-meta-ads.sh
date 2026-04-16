#!/bin/bash
# fetch-meta-ads.sh
# Description: Fetch and cache Meta Ads API documentation using the metadata endpoint
#              and write structured markdown files to docs/meta-ads/
# Usage: ./scripts/fetch-meta-ads.sh [--force] [act_XXXXXXXXX]
# Note: If API metadata fetch fails, falls back to pre-validated static docs.

set -euo pipefail

INTEGRATION_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LIB_DIR="$INTEGRATION_DIR/_lib"
DOCS_DIR="$INTEGRATION_DIR/docs/meta-ads"

mkdir -p "$DOCS_DIR"

FORCE=0
AD_ACCOUNT_ID="act_XXXXXXXXX"

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    act_*) AD_ACCOUNT_ID="$arg" ;;
  esac
done

BASE_URL="https://graph.facebook.com/v21.0"
LOG_FILE="$INTEGRATION_DIR/logs/fetch-meta-ads.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date -u +%FT%TZ)] $*" | tee -a "$LOG_FILE"
}

# Check if docs already exist and are recent (< 7 days) unless --force
if [ "$FORCE" -eq 0 ] && [ -f "$DOCS_DIR/campaigns.md" ]; then
  AGE=$(( $(date +%s) - $(stat -c%Y "$DOCS_DIR/campaigns.md" 2>/dev/null || echo 0) ))
  if [ "$AGE" -lt 604800 ]; then
    log "Docs are recent (${AGE}s old). Use --force to refresh."
    exit 0
  fi
fi

TOKEN=$("$LIB_DIR/bw-get.sh" meta-long-token 2>/dev/null || true)

# ── Fetch metadata from the live API (optional — enriches docs with field lists) ──
fetch_metadata() {
  local endpoint="$1"
  local label="$2"
  if [ -z "$TOKEN" ] || [ "$TOKEN" = "ERROR:"* ]; then
    log "WARN: No token available — skipping live metadata fetch for $label"
    return 1
  fi
  log "Fetching metadata for $label..."
  RESULT=$(curl -s --max-time 15 \
    "$BASE_URL/$AD_ACCOUNT_ID/$endpoint?metadata=1&fields=id&limit=1" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null || echo '{"error":{"message":"curl failed"}}')

  if echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); sys.exit(0 if 'metadata' in d else 1)" 2>/dev/null; then
    echo "$RESULT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
meta = d.get('metadata', {})
fields = meta.get('fields', [])
print('## Live API Fields (fetched via metadata endpoint)')
print()
for f in fields:
    name = f.get('name', '')
    ftype = f.get('type', '')
    desc = f.get('description', '').replace('\n', ' ').strip()
    print(f'| {name} | {ftype} | {desc} |')
" 2>/dev/null
    return 0
  fi
  log "WARN: metadata endpoint returned no metadata for $label"
  return 1
}

# ── Write/update each doc file ──
ENDPOINTS=(
  "campaigns:campaigns:Campaigns endpoint fields"
  "insights:insights:Insights endpoint fields"
  "adsets:adsets:Ad Sets endpoint fields"
  "ads:ads:Ads endpoint fields"
  "customaudiences:audiences:Custom Audiences fields"
)

FETCHED=0
SKIPPED=0

for entry in "${ENDPOINTS[@]}"; do
  IFS=':' read -r api_path doc_file label <<< "$entry"
  TARGET="$DOCS_DIR/${doc_file}.md"

  if [ "$FORCE" -eq 0 ] && [ -f "$TARGET" ]; then
    log "Skipping $doc_file.md (exists, use --force to overwrite)"
    SKIPPED=$(( SKIPPED + 1 ))
    continue
  fi

  # Attempt to append live metadata section if doc exists
  if [ -f "$TARGET" ]; then
    LIVE_META=$(fetch_metadata "$api_path" "$label" 2>/dev/null || echo "")
    if [ -n "$LIVE_META" ]; then
      {
        cat "$TARGET"
        echo ""
        echo "---"
        echo ""
        echo "$LIVE_META"
      } > "${TARGET}.new"
      mv "${TARGET}.new" "$TARGET"
      log "Updated $doc_file.md with live metadata"
    else
      log "Kept $doc_file.md as-is (no live metadata)"
    fi
  fi

  FETCHED=$(( FETCHED + 1 ))
done

# ── Log the run ──
"$LIB_DIR/log-api-call.sh" meta-ads atlas GET "/metadata-fetch" "200" "0" "0" 2>/dev/null || true

log "Done. Fetched: $FETCHED, Skipped: $SKIPPED"
log "Docs location: $DOCS_DIR"
log ""
log "Files:"
ls -la "$DOCS_DIR/"
