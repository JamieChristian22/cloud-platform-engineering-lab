#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TFVARS="${TFVARS_FILE:-terraform.tfvars}"
[[ -f "$ROOT/terraform/$TFVARS" ]] || { echo "Create terraform/$TFVARS from terraform.tfvars.example." >&2; exit 1; }
terraform -chdir="$ROOT/terraform" init
terraform -chdir="$ROOT/terraform" plan -input=false -out=tfplan -var-file="$TFVARS"
terraform -chdir="$ROOT/terraform" show -no-color tfplan > "$ROOT/evidence/terraform-plan.txt"
printf 'Plan saved to terraform/tfplan and evidence/terraform-plan.txt.\n'
