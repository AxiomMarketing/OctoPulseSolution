#!/bin/bash
# Re-index all API doc collections (for KAIROS nightly)
set -e
export PATH=$HOME/.bun/bin:$PATH

echo "[$(date -Iseconds)] Starting ClawMem re-index for API docs..."

for api in meta-ads shopify printful klaviyo posthog; do
  DOC_DIR="$HOME/octopulse/integrations/docs/$api"
  COLLECTION="docs-$api"

  if [ ! -d "$DOC_DIR" ] || [ -z "$(ls -A $DOC_DIR/*.md 2>/dev/null)" ]; then
    echo "  SKIP $COLLECTION (no .md files in $DOC_DIR)"
    continue
  fi

  # Ensure collection exists
  if ! clawmem doctor 2>&1 | grep -q "$COLLECTION"; then
    clawmem collection add "$DOC_DIR" --name "$COLLECTION"
    echo "  ADDED $COLLECTION"
  fi
done

# Re-embed everything
clawmem update --embed 2>&1 | tail -5

echo "[$(date -Iseconds)] Re-index complete."
