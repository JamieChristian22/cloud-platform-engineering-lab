#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for overlay in base overlays/dev overlays/prod; do
  kubectl kustomize "$ROOT/$overlay" >/dev/null
  printf 'PASS: rendered Kubernetes %s overlay.\n' "$overlay"
done
echo "Kustomize rendering does not establish cluster admission or runtime health."
