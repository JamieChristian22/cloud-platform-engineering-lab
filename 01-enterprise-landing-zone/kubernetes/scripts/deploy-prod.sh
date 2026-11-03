#!/usr/bin/env bash
set -euo pipefail

kubectl apply -k ./overlays/prod
kubectl rollout status deployment/prod-enterprise-web -n enterprise-landing-zone
kubectl get all -n enterprise-landing-zone
