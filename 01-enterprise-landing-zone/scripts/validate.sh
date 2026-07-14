#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
terraform -chdir="$ROOT/terraform" fmt -check -recursive
terraform -chdir="$ROOT/terraform" init -backend=false
terraform -chdir="$ROOT/terraform" validate
if command -v tflint >/dev/null; then (cd "$ROOT/terraform" && tflint --init && tflint --recursive); fi
if command -v checkov >/dev/null; then checkov -d "$ROOT/terraform" --config-file "$ROOT/terraform/.checkov.yaml"; fi
if command -v shellcheck >/dev/null; then shellcheck "$ROOT"/scripts/*.sh; fi
printf 'All validation checks passed.\n'
