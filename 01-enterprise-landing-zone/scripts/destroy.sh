#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF="$ROOT/terraform/terraform"
TFVARS="${TFVARS_FILE:-terraform.tfvars}"
[[ "$TFVARS" != *"/"* && "$TFVARS" != *".."* ]] || { echo "TFVARS_FILE must be a local filename." >&2; exit 1; }
[[ -f "$TF/$TFVARS" ]] || { echo "Missing terraform/terraform/$TFVARS." >&2; exit 1; }
echo "WARNING: This destroys managed infrastructure. Protected audit buckets may require deliberate manual cleanup."
terraform -chdir="$TF" destroy -input=false -var-file="$TFVARS"
