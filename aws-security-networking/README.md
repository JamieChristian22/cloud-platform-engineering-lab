# AWS Security Networking

## Overview

This project demonstrates secure AWS networking fundamentals for cloud security and cloud engineering roles.

## Services

- VPC
- Public and private subnets
- Route tables
- Internet Gateway
- NAT Gateway pattern
- Security Groups
- Network ACLs
- VPC Flow Logs
- CloudTrail
- GuardDuty
- IAM
- S3 logging bucket
- KMS encryption

## Architecture

```text
Internet
  |
Internet Gateway
  |
Public Subnet -- Bastion / Load Balancer
  |
Private Subnet -- Application / Internal Workloads
  |
VPC Flow Logs -> CloudWatch / S3
CloudTrail -> S3
GuardDuty -> Security Findings
```

## Security Controls

- No direct public access to private workloads
- Restrictive security group rules
- VPC Flow Logs enabled
- CloudTrail enabled
- GuardDuty enabled
- S3 block public access
- KMS encryption
- IAM least privilege

## Validation

- Confirm VPC exists
- Confirm subnets are segmented
- Confirm private resources are not public
- Confirm flow logs are enabled
- Confirm CloudTrail logs are stored
- Confirm GuardDuty is enabled


## CI/CD Implementation

This project includes a complete CI/CD workflow using GitHub Actions.

### Pipeline Capabilities

- Pull request validation
- Terraform formatting check
- Terraform initialization
- Terraform validation
- Secret scanning
- Infrastructure security review
- Docker build where applicable
- Dev deployment stage
- Staging deployment stage
- Production approval gate
- Post-deployment validation
- Evidence artifact generation

### CI/CD Files

```text
.github/workflows/complete-ci-cd-pipeline.yml
docs/ci-cd-pipeline.md
docs/environment-promotion.md
docs/rollback-runbook.md
docs/secrets-and-variables.md
```

### Hiring Value

This demonstrates practical DevOps engineering, release management, cloud automation, security gating, rollback readiness, and environment promotion practices.

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
