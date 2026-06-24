# CI/CD Platform

## Purpose

This CI/CD layer makes the portfolio stronger by showing how cloud infrastructure and application changes move safely from code to deployment.

## Pipeline Goals

- Validate code before deployment
- Check Terraform formatting
- Validate Terraform syntax
- Run infrastructure security checks
- Scan for secrets
- Build Docker images
- Run container security scanning
- Promote changes through dev, staging, and production
- Support rollback procedures
- Store deployment evidence

## Pipeline Stages

```text
Developer Commit
  |
  v
Pull Request
  |
  v
Static Validation
  |
  +--> Terraform fmt
  +--> Terraform validate
  +--> YAML lint
  +--> Secret scan
  +--> IaC security scan
  |
  v
Build
  |
  +--> Docker build
  +--> Unit test placeholder command
  +--> Container scan
  |
  v
Plan
  |
  +--> Terraform plan
  +--> Cost review
  +--> Security review
  |
  v
Deploy
  |
  +--> Dev environment
  +--> Staging environment
  +--> Production approval gate
  |
  v
Post-Deployment Validation
  |
  +--> Health check
  +--> Log check
  +--> Alert check
  +--> Evidence capture
```

## Environments

| Environment | Purpose | Approval |
|---|---|---|
| dev | Feature testing | Automatic |
| staging | Pre-production validation | Pull request review |
| production | Final deployment | Manual approval |

## Security Gates

| Gate | Purpose |
|---|---|
| Secret scanning | Prevents leaked credentials |
| Terraform validation | Prevents invalid IaC |
| IaC security scanning | Detects insecure cloud resources |
| Container scanning | Detects vulnerable images |
| Manual production approval | Prevents accidental production changes |

## Rollback Strategy

1. Identify failed deployment.
2. Review pipeline logs.
3. Confirm affected environment.
4. Revert the last commit or redeploy previous tag.
5. Re-run validation.
6. Confirm service health.
7. Document the incident.
8. Add preventive action.

## Evidence to Capture

- Successful pipeline run
- Failed pipeline run and fix
- Terraform validation output
- Security scan result
- Docker build result
- Deployment approval screenshot
- Rollback test result

## 10/10 Completion Additions

This project now includes deeper job-ready assets:

- Cloud-specific Terraform examples for AWS, Azure, and GCP
- Complete CI/CD workflow
- Kubernetes deployment manifest
- GitOps workflow structure
- SLI/SLO and error budget templates
- Incident postmortem template
- Capacity planning model
- Threat model
- Compliance control mapping
- Architecture decision record
- Monitoring dashboard template
- Live deployment checklist
- Validation evidence files

### Final Completion Standard

To finish this project as a live GitHub portfolio entry:

1. Deploy the safest free-tier version.
2. Capture screenshots into `evidence/screenshots/`.
3. Paste Terraform outputs into `evidence/validation/`.
4. Export the architecture diagram as PNG.
5. Update README with actual deployment evidence.
6. Commit changes to GitHub.
7. Link the project from the master portfolio README.
