#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF="$ROOT/terraform/terraform"
TFVARS="${TFVARS_FILE:-terraform.tfvars}"
[[ "$TFVARS" != *"/"* && "$TFVARS" != *".."* ]] || { echo "TFVARS_FILE must be a filename in terraform/terraform." >&2; exit 1; }
[[ -f "$TF/$TFVARS" ]] || { echo "Copy terraform/terraform/terraform.tfvars.example to terraform/terraform/$TFVARS and set your own values." >&2; exit 1; }
terraform -chdir="$TF" init -input=false
terraform -chdir="$TF" plan -input=false -out=tfplan -var-file="$TFVARS"
echo "Plan saved in terraform/terraform/tfplan. Treat plan files as sensitive; do not commit them."
