#!/bin/bash
# Usage: rate-limit.sh <service> <agent>
# Reads limits from registry.yml, checks state, returns 0=OK 1=exceeded
# State: ~/octopulse/integrations/rate-limit-state.json
set -e
SERVICE="$1"; AGENT="$2"
STATE_FILE="$HOME/octopulse/integrations/rate-limit-state.json"
REGISTRY="$HOME/octopulse/integrations/registry.yml"

# Parse rate limit from registry (using python for YAML)
LIMIT_HOUR=$(python3 -c "
import yaml
reg = yaml.safe_load(open('$REGISTRY'))
api = reg.get('apis',{}).get('$SERVICE',{})
print(api.get('rate_limits',{}).get('per_hour', 999999))
" 2>/dev/null || echo 999999)

# Load or init state
if [ ! -f "$STATE_FILE" ]; then echo '{}' > "$STATE_FILE"; fi

# Count calls in last hour for this agent+service
NOW=$(date +%s)
HOUR_AGO=$(( NOW - 3600 ))
KEY="${AGENT}_${SERVICE}"

COUNT=$(python3 -c "
import json
state = json.load(open('$STATE_FILE'))
calls = state.get('$KEY', [])
recent = [t for t in calls if t > $HOUR_AGO]
print(len(recent))
" 2>/dev/null || echo 0)

if [ "$COUNT" -ge "$LIMIT_HOUR" ]; then
  echo "RATE_LIMIT_EXCEEDED: $KEY has $COUNT calls in last hour (limit=$LIMIT_HOUR)" >&2
  exit 1
fi

# Increment
python3 -c "
import json
state = json.load(open('$STATE_FILE'))
calls = state.setdefault('$KEY', [])
calls.append($NOW)
# Cleanup old entries (>24h)
calls[:] = [t for t in calls if t > ($NOW - 86400)]
json.dump(state, open('$STATE_FILE','w'), indent=2)
" 2>/dev/null

echo "OK: $KEY $((COUNT+1))/$LIMIT_HOUR"
