#!/bin/bash
# Usage: log-api-call.sh <service> <agent> <method> <endpoint> <status> <latency_ms> <size>
SERVICE="$1"; AGENT="$2"; METHOD="$3"; ENDPOINT="$4"; STATUS="$5"; LATENCY="$6"; SIZE="$7"
LOG_DIR="$HOME/logs/integrations"
mkdir -p "$LOG_DIR"
printf '{"ts":"%s","service":"%s","agent":"%s","method":"%s","endpoint":"%s","status":%s,"latency_ms":%s,"size":%s}\n' \
  "$(date -u +%FT%TZ)" "$SERVICE" "$AGENT" "$METHOD" "$ENDPOINT" "$STATUS" "$LATENCY" "${SIZE:-0}" \
  >> "$LOG_DIR/${SERVICE}.jsonl"
