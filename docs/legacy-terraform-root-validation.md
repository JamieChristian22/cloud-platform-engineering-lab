# Legacy Terraform Roots — Audit and Non-Deployment Validation

Scope: the older Terraform modules under projects 01–04. The newer `05-aws-vpc-terraform-lab` has its own stricter dedicated GitHub Actions workflows. These directories are **different root modules**; they are not a single Terraform workspace, and they have not been deployed for this audit.

## Exact root boundaries

| CI label | Root directory | Intended infrastructure | High-priority review |
| --- | --- | --- | --- |
| 01 basic landing zone | `01-enterprise-landing-zone/terraform` | VPC, public/private subnet, IGW, web SG | Previously invalid SSH CIDR placeholder removed; HTTP/HTTPS remain public and egress is broad |
| 01 advanced landing zone | `01-enterprise-landing-zone/terraform/terraform` | Multi-AZ VPC, NAT, EC2, S3, CloudTrail, CloudWatch, IAM, KMS, budget, SNS | **Cost-intensive**: NAT hourly/data, EC2, logging, KMS. S3 audit bucket has `force_destroy=true` and a single NAT AZ; review data retention and DR |
| 02 multi-account governance | `02-multi-account-governance-platform/terraform` | AWS Organizations organizational units | Requires Organizations root ID and privileged administrator access. An accidental apply changes organization structure |
| 03 shared services | `03-shared-services-platform/terraform` | Shared VPC, subnets, IGW, CloudWatch logs | Public IP auto assignment and three CloudWatch groups; evaluate isolation, retention and cost |
| 04 observability | `04-enterprise-observability-platform/terraform` | SNS topic and CloudWatch dashboard | Potential charges and missing real alert subscriptions/metrics |

**Important:** Project 01 contains two Terraform roots, one **nested inside** the other. Terraform reads only `*.tf` files directly in the directory selected by `-chdir`; the CI job never runs recursive formatting that might mix these separate roots.

## Automated checks

The `.github/workflows/legacy-terraform-validation.yml` workflow has a five-root matrix, runs `terraform fmt -check -diff`, downloads provider plugins via `terraform init -backend=false -input=false -no-color`, then runs `terraform validate -no-color`. The separate Python inventory identifies five root directories, searches for invalid SSH CIDR placeholders, and reports high-risk cost/service types.

The root checks do **not** run `terraform plan` or `terraform apply`, do not configure an AWS backend, and use no AWS credentials. They establish formatting and structural validity, **not** an approved deployment architecture, a security certification, or reliable AWS account-specific behavior.

Terraform provider downloads contact the public provider registry and may vary until root-specific lock files are committed. Dependency lock files and more extensive security findings are future hardening work.

## Why each command matters

- `terraform -chdir=PATH fmt -check -diff`: verify canonical formatting of the exact root and show diffs without editing committed files.
- `terraform -chdir=PATH init -backend=false -input=false -no-color`: install provider plugins and resolve the module graph; avoid configuring a backend or requesting interactive input.
- `terraform -chdir=PATH validate -no-color`: check configuration syntax, resource attribute support, references and required providers. Missing variable values can still be accepted at validation time.
- `python3 scripts/legacy_terraform_audit.py`: print a no-cloud resource/cost-risk inventory of the five separate root modules.

## Deployment policy

**Do not execute `terraform apply` or `terraform destroy` in any of these legacy modules without a separate, explicit owner review, cost approval, IAM permission review, and cleanup plan.** A `terraform plan` can also require AWS credentials, make read API calls and interact with a backend; this audit intentionally does not perform it.

The advanced landing zone contains a monthly AWS budget alert; a budget alert **does not cap charges**. Treat this repository as source-level engineering training, not proof of running production infrastructure.

## Audit conclusions and unresolved work

1. The basic landing-zone example previously had an invalid `YOUR_IP_ADDRESS/32` SSH ingress placeholder. That ingress rule was **removed**, rather than replacing it with an unreviewed real IP.
2. The advanced root still models a NAT Gateway, EIP, EC2, multi-region CloudTrail and KMS. Review costs, actual IAM scoping and security policies before any deployment.
3. Each root is checked in an isolated CI matrix job. Future phases should add root-specific lock files and targeted policy scans without forcing one root's configuration onto another.
4. Terraform validation alone cannot verify application networking, real AWS quotas, or provisioned resource security. Capture no fabricated "deployed" screenshots.
