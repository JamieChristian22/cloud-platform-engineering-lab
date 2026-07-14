#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
URL="$(terraform -chdir="$ROOT/terraform" output -raw web_url)"
for attempt in {1..20}; do
  if response="$(curl --fail --silent --show-error --max-time 10 "$URL")"; then
    grep -q "AWS Enterprise Landing Zone" <<<"$response"
    printf 'Smoke test passed: %s\n' "$URL"
    exit 0
  fi
  printf 'Attempt %s failed; retrying in 15 seconds...\n' "$attempt"
  sleep 15
done
echo "Smoke test failed after 20 attempts." >&2
exit 1
