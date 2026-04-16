#!/bin/bash
# Usage: validate-request.sh <service> <endpoint> <payload_json_string>
SERVICE="$1"; ENDPOINT="$2"; PAYLOAD="$3"
[ -z "$SERVICE" ] || [ -z "$ENDPOINT" ] || [ -z "$PAYLOAD" ] && { echo "Usage: validate-request.sh <service> <endpoint> <payload_json>" >&2; exit 2; }

SCHEMA_DIR="$HOME/octopulse/integrations/schemas/$SERVICE"
ENDPOINT_CLEAN=$(echo "$ENDPOINT" | sed 's|^/||; s|/|-|g')
SCHEMA_FILE="$SCHEMA_DIR/${ENDPOINT_CLEAN}-request.schema.json"

TMPFILE=$(mktemp)
echo "$PAYLOAD" > "$TMPFILE"
~/octopulse/kairos/venv/bin/python3 ~/octopulse/integrations/_lib/validate-request.py "$SCHEMA_FILE" "$TMPFILE"
RC=$?
rm -f "$TMPFILE"
exit $RC
