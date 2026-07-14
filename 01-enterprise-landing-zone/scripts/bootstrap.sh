#!/usr/bin/env bash
set -euo pipefail
for cmd in terraform aws curl; do command -v "$cmd" >/dev/null || { echo "Missing required command: $cmd" >&2; exit 1; }; done
aws sts get-caller-identity >/dev/null
terraform -chdir="$(dirname "$0")/../terraform" init -upgrade
printf 'Bootstrap completed successfully.\n'
