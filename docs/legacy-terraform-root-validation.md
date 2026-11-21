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

## Advisory Terraform security scanning

The separate `.github/workflows/legacy-terraform-security.yml` workflow scans each of the **same five roots** using Checkov 3.4.6. It copies only the selected root's immediate `*.tf` files to a disposable temporary directory before scanning. This is deliberate: scanning the basic landing zone recursively would accidentally include the different advanced landing-zone root.

Each root has its own downloadable JSON artifact and a full findings summary in GitHub Actions. The scan **does not deploy AWS resources**, uses no AWS credentials, and fails if scanner output is incomplete or invalid. Existing policy findings are **advisory**, not fixed or silently ignored. CI passing means that a complete security scan ran, **not** that Checkov found zero problems.

### Actual security scan results

[GitHub Actions run 44862770622](https://github.com/JamieChristian22/cloud-platform-engineering-lab/actions/runs/44862770622) scanned the five Terraform roots **independently** with Checkov 3.4.6. All five scanning jobs ran successfully, with no Checkov parsing errors. These are actual source findings, not deployed AWS resource observations.

| Root | Checkov passed controls | Unremediated advisory findings | Investigate first |
| --- | ---: | ---: | --- |
| 01 basic landing zone | 8 | **6** | Public subnet IP assignment, internet-wide HTTP ingress, broad egress, unconfigured VPC flow logging/default SG |
| 01 advanced landing zone | 63 | **18** | Public EC2/subnet exposure, broad IAM and SG rules, CloudTrail/S3/KMS controls, AZ selection, cost and recovery risks |
| 02 governance | 1 | **0** | No Checkov findings in this minimal source root; privileged AWS Organizations actions are still high-impact |
| 03 shared services | 7 | **9** | Public IP assignment, CloudWatch encryption and retention controls, default SG/flow logging |
| 04 observability | 1 | **1** | SNS topic encryption policy |
| **Total** | **80** | **34** | Findings are still open; no deployment has occurred |

All 34 findings remain **visible and unwaived** in the individual JSON artifacts from the GitHub Actions run. A successful *advisory* job means that Checkov ran and produced a parseable report; it **does not** mean that any failing security control passed.

### Prioritized remediation backlog

1. **P1 — Exposure and access:** Revisit broad ingress/egress, auto-assigned public IPs, unscoped IAM permissions and default security-group rules. Do not open public ports for convenience. Existing application functionality must be reviewed before changing behavior.
2. **P1 — Audit-log protection:** Review advanced landing-zone audit bucket deletion settings (`force_destroy=true`), CloudTrail and S3 policies, key management, event logging, and recovery/retention requirements.
3. **P2 — Reliability and cost:** The advanced root creates a NAT gateway/EIP and EC2 resources, and has a single NAT failure dependency. Review two-AZ resilience and expected monthly charges before any live rollout.
4. **P2 — Monitoring and retention:** Shared-services CloudWatch logging and VPC flow logging require policy decisions; the SNS topic in project 04 needs encryption review.
5. **P2 — Reproducibility:** Add root-specific provider lock files and test expected network behavior using mocked Terraform providers before promoting a legacy root.

Any security exception in a future production context must have an accountable reviewer, rationale, scope, compensating controls and review date. The status today is **validated Terraform source + advisory security findings**, not production approval.

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
