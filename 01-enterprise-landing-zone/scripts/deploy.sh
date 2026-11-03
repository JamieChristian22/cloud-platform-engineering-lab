#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF="$ROOT/terraform/terraform"
[[ -f "$TF/tfplan" ]] || { echo "No reviewed plan found. Run make plan first." >&2; exit 1; }
echo "Applying the existing reviewed plan. AWS charges may apply."
terraform -chdir="$TF" apply -input=false tfplan
echo "Apply returned successfully. Verify service health and alert subscriptions separately."
