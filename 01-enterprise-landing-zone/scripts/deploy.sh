#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -f "$ROOT/terraform/tfplan" ]] || "$ROOT/scripts/plan.sh"
terraform -chdir="$ROOT/terraform" apply -input=false -auto-approve tfplan
terraform -chdir="$ROOT/terraform" output -json > "$ROOT/evidence/terraform-outputs.json"
printf 'Deployment completed. Confirm the SNS subscription email before expecting alerts.\n'
