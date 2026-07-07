#!/usr/bin/env bash
set -euo pipefail

kubectl kustomize ./base >/tmp/enterprise-landing-zone-base.yaml
kubectl kustomize ./overlays/dev >/tmp/enterprise-landing-zone-dev.yaml
kubectl kustomize ./overlays/prod >/tmp/enterprise-landing-zone-prod.yaml

echo "Kubernetes manifests rendered successfully."
