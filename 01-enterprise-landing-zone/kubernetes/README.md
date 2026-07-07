# Kubernetes Platform Layer — AWS Enterprise Landing Zone

This folder adds a Kubernetes-ready workload layer for the `01-enterprise-landing-zone` project.

It is designed to demonstrate how a cloud platform engineer would deploy a secure, observable, and scalable application foundation on top of an enterprise landing zone.

## What This Includes

- Namespace isolation
- ServiceAccount and least-privilege RBAC
- NGINX web application deployment
- ClusterIP service
- Ingress-ready routing
- Horizontal Pod Autoscaler
- Pod Disruption Budget
- NetworkPolicy controls
- ConfigMap-driven environment settings
- Secret template for sensitive values
- Kustomize overlays for dev and prod
- Validation and deployment scripts

## Folder Structure

```text
kubernetes/
├── base/
│   ├── namespace.yaml
│   ├── serviceaccount.yaml
│   ├── rbac.yaml
│   ├── configmap.yaml
│   ├── secret.example.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── hpa.yaml
│   ├── pdb.yaml
│   ├── networkpolicy.yaml
│   └── kustomization.yaml
├── overlays/
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   └── patch-replicas.yaml
│   └── prod/
│       ├── kustomization.yaml
│       └── patch-replicas.yaml
├── scripts/
│   ├── deploy-dev.sh
│   ├── deploy-prod.sh
│   ├── validate.sh
│   └── cleanup.sh
└── docs/
    └── kubernetes-runbook.md
```

## Prerequisites

- Kubernetes cluster access
- `kubectl` installed
- Metrics Server installed for HPA
- Ingress controller installed if using Ingress
- Optional: AWS Load Balancer Controller for AWS EKS ingress integration

## Deploy Dev

```bash
cd kubernetes
./scripts/validate.sh
./scripts/deploy-dev.sh
```

## Deploy Prod

```bash
cd kubernetes
./scripts/validate.sh
./scripts/deploy-prod.sh
```

## Verify

```bash
kubectl get all -n enterprise-landing-zone
kubectl get hpa -n enterprise-landing-zone
kubectl get pdb -n enterprise-landing-zone
kubectl get networkpolicy -n enterprise-landing-zone
kubectl describe ingress enterprise-web-ingress -n enterprise-landing-zone
```

## Cleanup

```bash
cd kubernetes
./scripts/cleanup.sh
```

## Portfolio Skills Demonstrated

- Kubernetes workload deployment
- Platform engineering
- Container orchestration
- Namespace governance
- RBAC security
- Network segmentation
- Application availability
- Autoscaling
- Operational runbooks
- Kustomize environment management
