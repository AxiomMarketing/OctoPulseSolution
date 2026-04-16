#!/bin/bash
# Usage: retry-backoff.sh <max_retries> <base_sec> <command...>
# Retries on exit != 0, exponential backoff
MAX="$1"; BASE="$2"; shift 2
for i in $(seq 0 "$MAX"); do
  "$@" && exit 0
  [ "$i" -lt "$MAX" ] && sleep $(( BASE * (2 ** i) ))
done
exit 1
