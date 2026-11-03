#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF="$ROOT/terraform/terraform"
URL="$(terraform -chdir="$TF" output -raw web_url)"
[[ "$URL" == http://* || "$URL" == https://* ]] || { echo "Unexpected URL scheme" >&2; exit 1; }
for attempt in {1..20}; do
  if response="$(curl --fail --silent --show-error --max-time 10 "$URL")" && grep -q "AWS Enterprise Landing Zone" <<<"$response"; then
    echo "Smoke test passed for configured web endpoint."
    exit 0
  fi
  echo "Attempt $attempt failed; retrying in 15 seconds..."
  sleep 15
done
echo "Smoke test failed after 20 attempts." >&2
exit 1
