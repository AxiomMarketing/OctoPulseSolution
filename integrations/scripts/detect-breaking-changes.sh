#!/bin/bash
# Compare current docs with yesterday's snapshot, detect breaking changes
# Exit 0 = no breaking change, Exit 2 = breaking change detected
set -e
INTEGRATIONS="$HOME/octopulse/integrations"
SNAPSHOT_DIR="$INTEGRATIONS/docs/_snapshots"
YESTERDAY=$(date -d "yesterday" +%F 2>/dev/null || date -v-1d +%F)
YESTERDAY_SNAPSHOT="$SNAPSHOT_DIR/docs-${YESTERDAY}.tar.gz"

if [ ! -f "$YESTERDAY_SNAPSHOT" ]; then
  echo "No yesterday snapshot ($YESTERDAY_SNAPSHOT) — skip diff"
  exit 0
fi

# Extract yesterday to tmp
TMP=$(mktemp -d)
tar xzf "$YESTERDAY_SNAPSHOT" -C "$TMP"

BREAKING=0
CHANGES=""

for api in meta-ads shopify printful klaviyo posthog; do
  OLD_DIR="$TMP/docs/$api"
  NEW_DIR="$INTEGRATIONS/docs/$api"
  [ ! -d "$OLD_DIR" ] && continue
  [ ! -d "$NEW_DIR" ] && continue

  # Diff markdown files
  for f in "$NEW_DIR"/*.md; do
    [ ! -f "$f" ] && continue
    FNAME=$(basename "$f")
    OLD_FILE="$OLD_DIR/$FNAME"
    [ ! -f "$OLD_FILE" ] && { CHANGES="$CHANGES\n[NEW] $api/$FNAME"; continue; }

    # Check for removed endpoints (lines starting with "### " or "## " that disappeared)
    REMOVED=$(diff "$OLD_FILE" "$f" 2>/dev/null | grep "^< ##" | head -5)
    if [ -n "$REMOVED" ]; then
      CHANGES="$CHANGES\n[REMOVED_SECTION] $api/$FNAME: $REMOVED"
      BREAKING=1
    fi
  done

  # Check for deleted files
  for f in "$OLD_DIR"/*.md; do
    [ ! -f "$f" ] && continue
    FNAME=$(basename "$f")
    [ "$FNAME" = "_meta.yml" ] && continue
    if [ ! -f "$NEW_DIR/$FNAME" ]; then
      CHANGES="$CHANGES\n[DELETED] $api/$FNAME"
      BREAKING=1
    fi
  done
done

rm -rf "$TMP"

if [ -n "$CHANGES" ]; then
  echo "Changes detected:"
  echo -e "$CHANGES"

  # Write CHANGELOG
  DATE=$(date +%F)
  echo -e "## $DATE\n$CHANGES\n" >> "$INTEGRATIONS/docs/CHANGELOG.md"
fi

if [ "$BREAKING" -eq 1 ]; then
  echo "BREAKING CHANGE DETECTED"
  exit 2
fi

echo "No breaking changes"
exit 0
