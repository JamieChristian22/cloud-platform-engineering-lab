#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF="$ROOT/terraform/terraform"
terraform -chdir="$TF" fmt -check -recursive
terraform -chdir="$TF" init -backend=false -input=false
terraform -chdir="$TF" validate -no-color
if command -v tflint >/dev/null; then (cd "$TF" && tflint --init && tflint); fi
if command -v checkov >/dev/null; then checkov -d "$TF"; fi
if command -v shellcheck >/dev/null; then shellcheck "$ROOT"/scripts/*.sh; fi
printf 'Canonical Terraform validation completed.\n'
