#!/usr/bin/env bash
set -euo pipefail

kubectl delete -k ./overlays/prod --ignore-not-found=true
kubectl delete -k ./overlays/dev --ignore-not-found=true
kubectl delete namespace enterprise-landing-zone --ignore-not-found=true
