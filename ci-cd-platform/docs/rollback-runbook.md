# CI/CD Rollback Runbook

## Purpose

This runbook explains how to recover from a failed deployment.

## Rollback Triggers

- Application health check fails
- Error rate increases
- Latency breaches SLO
- Security scan detects critical issue
- Terraform deployment changes unintended resources
- Users report service outage

## Rollback Steps

1. Stop additional deployments.
2. Identify the failed workflow run.
3. Review logs for the failing stage.
4. Confirm whether infrastructure, application, or configuration caused the issue.
5. Revert to the previous known-good commit.
6. Re-run validation pipeline.
7. Deploy previous stable version.
8. Confirm health checks pass.
9. Monitor logs, metrics, and alerts for at least 30 minutes.
10. Document root cause and prevention step.

## Rollback Commands

```bash
git log --oneline
git revert <bad_commit_sha>
git push origin main
```

## Terraform Rollback

```bash
terraform plan
terraform apply
```

Use Terraform state carefully. Never manually edit state unless absolutely required and approved.

## Post-Rollback Evidence

- Failed pipeline screenshot
- Successful rollback pipeline screenshot
- Error logs
- Health check result
- Timeline
- Root cause
- Corrective action
