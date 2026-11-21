# Terraform Security Assessment — AWS VPC Lab

**Assessment scope:** Only `05-aws-vpc-terraform-lab/`, with targeted CI workflow checks. The other 01–04 platform projects are **out of scope**. This is a repository security assessment, **not an AWS account penetration test or compliance certification**.

**Assessment mode:** CI-only. No AWS credentials, API provisioning, billing or actual network traffic. VPC security group behavior and CloudWatch functionality are modeled and tested with mocked Terraform providers.

## Toolchain

- `terraform fmt -check -recursive` checks HCL style.
- `terraform validate` checks Terraform configuration structure.
- `terraform test -no-color` checks simulated network, security-group, routing and opt-in monitoring behavior.
- `security/policy_gate.py` is a hard-failing local guardrail for specific regressions: permissive SG ingress/SSH, unexpected opt-in monitoring resource creation, unpinned Actions, and dangerous workflow triggers/deployment commands. This is intentionally narrow and should **not** be described as a full Terraform security scanner.
- **Checkov 3.4.6**, installed into a temporary Python venv, conducts a broader Terraform IaC misconfiguration audit. The full report is uploaded as a GitHub Actions JSON artifact for reviewer inspection. The initial full scan is advisory (`--soft-fail`) while findings are triaged; **CI success does not mean Checkov found zero issues**.
- GitHub Actions uses read-only repository permissions, no persisted checkout credentials, immutable action commit SHAs, concurrency cancellation, and no AWS credentials. Checkov code itself is a pinned PyPI release, but its transitive dependencies are **not fully hash-locked**; supply-chain hardening remains an ongoing item.

## Threat model and key controls

| Risk / control | Current implementation | Review status |
|---|---|---|
| SSH reachable from public internet | No SSH ingress in lab security groups; regression gate checks ingress rules | Modeled; verify real security groups separately |
| Public web ingress inadvertently opened | Web TCP 443 ingress limited to `var.vpc_cidr` | Mock-tested; no workload attached |
| Unintended security group egress | Explicit web-to-app outbound TCP 8080; evaluate any real AWS default/out-of-band rules if deployed | Needs live review for effective rules |
| Unexpected AWS observability charges | All live Flow Logs, IAM delivery and CloudWatch resources are behind `enable_flow_logs=false` | Tested in mocked Terraform plan |
| Private subnet internet egress | No private default internet route | Mock-tested, not deployed |
| Pipeline deploys resources | Validation/security workflows contain no apply/destroy; CI has no AWS authorization | Hard-gated for these workflows |
| CloudWatch Logs at-rest encryption | Optional log group relies on AWS default service-managed encryption; no customer-managed KMS key configured | **Known design limitation** if customer-managed key is required |
| CloudWatch Logs retention | Optional 7-day retention; may not meet regulated retention standards | **Known design limitation**; select approved retention before real workloads |
| Network telemetry completeness | Flow Logs disabled by default and synthetic data used for demonstrations | **Known gap** for production observability |

## Findings triage

The full Checkov scan's actual finding IDs and resource locations should be taken from the generated `aws-vpc-terraform-checkov-report` artifact on PR and main workflows. At creation, this document does **not** claim that every scanner finding is remediated or that the repository is free of security problems.

Any future exception should be documented by check ID, relevant resource, risk, decision maker, rationale, expiration/review date, and compensating control. Do not add broad ignore patterns simply to turn CI green.

## Why this is a staged gate

The broader Checkov scan intentionally reports all detected misconfigurations without forcing an early pass/fail decision. The narrowly specified regression gate is blocking. After reviewing the full Checkov results, high-impact issues should be fixed or explicitly accepted with documented reasoning, and enforceable Checkov checks promoted into the blocking gate. **Do not present an advisory result as a security clearance.**

## Run locally (no AWS resources)

From repository root:

```sh
python3 -m unittest discover -s 05-aws-vpc-terraform-lab/security -p 'test_*.py' -v
python3 05-aws-vpc-terraform-lab/security/policy_gate.py
python3 -m venv .checkov-venv
.checkov-venv/bin/python -m pip install 'checkov==3.4.6'
.checkov-venv/bin/checkov -d 05-aws-vpc-terraform-lab --framework terraform --skip-download --output json --soft-fail
```

Do not add deployment commands to the CI workflow. Avoid committing `.checkov-venv/`, generated scanner JSON files containing project details, credentials, Terraform plan/state files or non-synthetic logs.

## Evidence

Use the exact GitHub Actions run URL and commit hash to demonstrate reproducible tests. Report deployment evidence separately only after an explicitly approved cloud deployment. Security assessment is limited to source-level analysis.
