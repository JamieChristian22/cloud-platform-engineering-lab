#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TFVARS="${TFVARS_FILE:-terraform.tfvars}"
[[ -f "$ROOT/terraform/$TFVARS" ]] || { echo "Missing terraform/$TFVARS." >&2; exit 1; }
terraform -chdir="$ROOT/terraform" destroy -input=false -auto-approve -var-file="$TFVARS"
printf 'Infrastructure destroyed. Review the AWS Billing console for remaining resources.\n'
