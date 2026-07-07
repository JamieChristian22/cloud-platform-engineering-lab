# Kubernetes Runbook

## Purpose

This runbook supports the Kubernetes workload layer for the AWS Enterprise Landing Zone portfolio project.

## Daily Checks

```bash
kubectl get pods -n enterprise-landing-zone
kubectl get deploy -n enterprise-landing-zone
kubectl get hpa -n enterprise-landing-zone
kubectl get events -n enterprise-landing-zone --sort-by=.lastTimestamp
```

## Health Check

```bash
kubectl port-forward svc/enterprise-web-service 8080:80 -n enterprise-landing-zone
curl http://localhost:8080/healthz
```

Expected result:

```text
healthy
```

## Troubleshooting Pods

```bash
kubectl describe pod -n enterprise-landing-zone -l app.kubernetes.io/name=enterprise-web
kubectl logs -n enterprise-landing-zone -l app.kubernetes.io/name=enterprise-web
```

## Restart Deployment

```bash
kubectl rollout restart deployment/enterprise-web -n enterprise-landing-zone
kubectl rollout status deployment/enterprise-web -n enterprise-landing-zone
```

## Scaling

```bash
kubectl scale deployment enterprise-web --replicas=3 -n enterprise-landing-zone
```

## Security Review

Validate these controls:

- Pods run as non-root
- Privilege escalation disabled
- Linux capabilities dropped
- Read-only root filesystem enabled
- RBAC limited to ConfigMap read access
- NetworkPolicy applied
- Namespace separation enabled

## Evidence Screenshots

Capture these screenshots for the portfolio:

1. Namespace created
2. Deployment running
3. Pods healthy
4. Service created
5. Ingress created
6. HPA configured
7. PDB configured
8. NetworkPolicy configured
9. RBAC Role and RoleBinding
10. Successful health check
