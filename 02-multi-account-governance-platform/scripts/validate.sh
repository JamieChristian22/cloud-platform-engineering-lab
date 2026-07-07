#!/usr/bin/env bash
set -euo pipefail

echo "== Namespaces =="
kubectl get namespaces --show-labels

echo "== RBAC =="
kubectl get rolebindings,clusterrolebindings -A

echo "== Resource Governance =="
kubectl get resourcequota,limitrange -A

echo "== Network Policies =="
kubectl get networkpolicy -A

echo "== Kyverno Policies, if installed =="
kubectl get cpol,pol -A 2>/dev/null || true

echo "== Gatekeeper Constraints, if installed =="
kubectl get constraints 2>/dev/null || true
