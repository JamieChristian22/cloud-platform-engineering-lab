# AWS Landing Zone | Infrastructure as Code & Platform Validation

**Status:** reviewed source-code lab and automated validation; **live AWS apply not yet independently verified**. This is a **single-account, enterprise-inspired AWS platform demo**, not an AWS Organizations multi-account landing zone or a production-certification claim.

## Design overview

The canonical Terraform root is **[`terraform/terraform/`](terraform/terraform/)**. There are no parallel Terraform configurations. The platform defines:

| Layer | Implemented in code | Design boundary |
|---|---|---|
| Networking | VPC, two public and two private subnets across available AZs, internet gateway, route tables | NAT is **opt-in**; when disabled, private subnets have no default internet route |
| Compute | Amazon Linux 2023 EC2 web demo with IMDSv2, SSM instance profile, encrypted gp3 root volume | Public IPv4 and plaintext HTTP are **lab-only** |
| Security | No SSH inbound, KMS encryption policies, private audit bucket, HTTPS-only bucket access | Single account; no AWS Organizations/Control Tower, SCPs, WAF or TLS endpoint |
| Audit | Multi-region CloudTrail, S3 encryption/versioning, VPC Flow Logs to encrypted CloudWatch Logs | KMS delivery and real log ingestion require account-level verification |
| Operations | CloudWatch CPU alarm, customer-managed-key SNS alerts, cost budget notifications | Email subscriptions must be confirmed; alarms must be tested |
| Kubernetes | Kustomize dev/prod overlays, workload hardening, HPA/PDB/NetworkPolicy | Kubernetes cluster and EKS **not** provisioned by Terraform |

[Architecture decisions](architecture/architecture-decisions.md) · [Implementation guide](docs/implementation-guide.md) · [Security baseline](docs/security-baseline.md) · [Operations runbook](docs/operations-runbook.md) · [Validation/evidence matrix](docs/VALIDATION_MATRIX.md)

## Offline checks (no AWS billing or credentials needed for tests)

```bash
python3 -m unittest discover -s tests -v
make validate
cd kubernetes && ./scripts/validate.sh
```

Python checks cover deployment-script safety and source invariants. Terraform validation needs Terraform >= 1.7 and network access to provider downloads. Optional TFLint, Checkov and ShellCheck are used when installed. The repository GitHub Actions workflow runs repository tests, shell syntax checks, Terraform format/init/validate, and Kubernetes rendering.

## Deploy in an isolated AWS sandbox (billable)

```bash
cp terraform/terraform/terraform.tfvars.example terraform/terraform/terraform.tfvars
# Set a real notification_email and review budget, region and instance type.
# NAT costs extra; enable_nat_gateway=false is the recommended lab default.
make bootstrap
make plan
# Inspect terraform/terraform/tfplan before applying. Do not commit plan/state files.
make deploy
make test
```

**Do not** run this against an account with existing Terraform-managed infrastructure until you review the state addresses and migration implications. Use separate, securely locked/encrypted state for shared workflows. `make deploy` requires a saved plan and will not regenerate one implicitly. `make destroy` prompts, and the audit bucket intentionally blocks force deletion; review retained evidence and AWS billing after cleanup.

## Evidence rules

- [Live acceptance checklist](evidence/project-completion-checklist.md): incomplete until a deployment is actually performed.
- [Recorded validation status](evidence/validation-results.md): distinguishes verified CI steps from pending AWS tests.
- [Evidence collection guide](evidence/deployment-evidence.md): exact commands, dates and sanitized outputs, **not** unverified screenshots or invented results.
- Legacy console/SSH guides in individual subject folders describe earlier manual work and **are not the authoritative Terraform deployment**.

## Limitations and security

The NAT gateway is disabled by default to limit charges. If enabled, it is **one** NAT gateway and therefore not highly available. The public demo serves HTTP, not HTTPS; this must not be treated as a production access pattern. The audit bucket has a 365-day current-object expiration policy and versioning; retention suitability, noncurrent-object costs, regulatory requirements and key policies need an account-specific review. State and plans can include secrets; store them outside the repository.

**No main-branch changes or AWS deployments occur automatically because this documentation or the CI workflow exists.**
