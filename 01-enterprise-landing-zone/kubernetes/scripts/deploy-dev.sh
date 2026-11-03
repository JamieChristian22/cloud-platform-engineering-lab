#!/usr/bin/env bash
set -euo pipefail

kubectl apply -k ./overlays/dev
kubectl rollout status deployment/dev-enterprise-web -n enterprise-landing-zone
kubectl get all -n enterprise-landing-zone
