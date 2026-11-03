# Landing-zone validation and evidence matrix

**Scope:** code and lab documentation. This document does not certify a live AWS environment.

| Control | Repository check | Live acceptance evidence needed |
| --- | --- | --- |
| Canonical Terraform root | `python -m unittest discover -s tests -v` | Successful `terraform plan` and reviewed plan |
| Terraform syntax/provider schema | `terraform fmt -check -recursive`, `terraform init -backend=false`, `terraform validate` | Provider authentication, region capacity and plan output |
| Network segmentation | Review `terraform/terraform/network.tf` | VPC, route-table and subnet IDs, private routing test |
| SSM management / no SSH ingress | Static regression test and security group review | SSM session and security group inspection |
| Audit logging | Review `logging.tf` | CloudTrail status, delivery, KMS access and log retrieval |
| Observability | Review `monitoring.tf` | Triggered alarm, confirmed SNS subscription and timestamp |
| Web service | `make test` after apply | HTTP response, instance ID and timestamp |
| Kubernetes manifests | GitHub Actions: `kubectl kustomize` base/dev/prod | Cluster-side server dry run, policy enforcement, ingress and HPA behavior |
| Deployment scripts | Offline mocked Python tests and ShellCheck | AWS plan/apply/change-management review |
| Cost control | Static NAT opt-in and AWS Budget configuration | Budget confirmation, live billing and residual costs |
| Cost | Budget definition and documented NAT gateway cost | Actual AWS Cost Explorer and budget subscription |

## Evidence recording template

Record UTC time, AWS region, sanitized account alias, git commit, Terraform version, plan SHA-256, relevant resource IDs (redacted as needed), exact command, exit code, and a sanitized output excerpt. Never commit Terraform state, plan files, tokens, session URLs or unredacted console screenshots.

**Unverified until executed:** Terraform plan/apply, live CloudTrail delivery, SNS email confirmation, EKS/Kubernetes deployment, HTTP smoke test, and actual monthly cost. CI static checks are not substitutes for these live checks.

## Known lab tradeoffs

- NAT gateway is off by default; enabling one creates a billed, single-AZ availability dependency. Use NAT per AZ or VPC endpoints for higher availability.
- Public HTTP is a demo-only endpoint, not a production TLS service.
- A 365-day log expiration is a lab policy, not a compliance retention determination.
- SSM access requires an authorized operator and working agent/network path.
- KMS key permissions and CloudTrail delivery must be tested in the target account before calling the design operational.
