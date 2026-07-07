#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$ROOT_DIR/namespaces/"
kubectl apply -f "$ROOT_DIR/rbac/"
kubectl apply -f "$ROOT_DIR/resource-governance/"
kubectl apply -f "$ROOT_DIR/network-policies/"
kubectl apply -f "$ROOT_DIR/policy-as-code/kyverno/" || true
kubectl apply -f "$ROOT_DIR/policy-as-code/gatekeeper/" || true
kubectl apply -f "$ROOT_DIR/monitoring/"

echo "Kubernetes governance platform manifests applied."
