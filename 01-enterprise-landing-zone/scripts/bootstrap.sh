#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for cmd in terraform aws curl; do command -v "$cmd" >/dev/null || { echo "Missing required command: $cmd" >&2; exit 1; }; done
aws sts get-caller-identity >/dev/null
terraform -chdir="$ROOT/terraform/terraform" init
printf 'Initialized canonical Terraform root: terraform/terraform.\n'
