# Terraform Security Assessment — AWS VPC Lab

**Assessment scope:** Only `05-aws-vpc-terraform-lab/`, with targeted CI workflow checks. The other 01–04 platform projects are **out of scope**. This is a repository security assessment, **not an AWS account penetration test or compliance certification**.

**Assessment mode:** CI-only. No AWS credentials, API provisioning, billing or actual network traffic. VPC security group behavior and CloudWatch functionality are modeled and tested with mocked Terraform providers.

## Toolchain

- `terraform fmt -check -recursive` checks HCL style.
- `terraform validate` checks Terraform configuration structure.
- `terraform test -no-color` checks simulated network, security-group, routing and opt-in monitoring behavior.
- `security/policy_gate.py` is a hard-failing local guardrail for specific regressions: permissive SG ingress/SSH, unexpected opt-in monitoring resource creation, unpinned Actions, and dangerous workflow triggers/deployment commands. This is intentionally narrow and should **not** be described as a full Terraform security scanner.
- **Checkov 3.4.6**, installed into a temporary Python venv, conducts a broader Terraform IaC misconfiguration audit. The full report is uploaded as a GitHub Actions JSON artifact for reviewer inspection. The full scan emits a JSON report with `--soft-fail` so evidence is retained. Its separate **blocking parser gate** fails on malformed scans or any finding not matching one of the two precisely documented unattached-security-group exceptions; the remediated Checkov policies are separately hard-gated. **CI success does not mean Checkov found zero issues**.
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

## Verified initial Checkov scan and remediation decisions

First successful Checkov report from PR #7 at commit `fdd091f` (GitHub Actions security audit):
**35 passed, 4 failed, 0 skipped, 0 parsing errors**. The report was generated with
Checkov 3.4.6 on source Terraform, with no cloud resources created.

| Checkov finding | Affected source | Decision |
| --- | --- | --- |
| `CKV_AWS_394` | `data.aws_availability_zones.available` | Remediate by constraining zone selection using explicit `zone-id` allowlist (not a broad `state=available` query) |
| `CKV2_AWS_12` | `aws_vpc.lab` | Remediate by managing the newly created VPC's default security group with zero ingress/egress rules |
| `CKV2_AWS_5` | `aws_security_group.web` | Accepted lab limitation: no workload or ENI is created to attach the security group; attaching it requires a future separately reviewed workload module |
| `CKV2_AWS_5` | `aws_security_group.app` | Same accepted lab limitation; document and verify attachment only when a workload exists |

Follow-up run at commit `6b2a6e1` ([GitHub Actions security audit](https://github.com/JamieChristian22/cloud-platform-engineering-lab/actions/runs/44861539455)) verified **37 passed, 2 failed, 0 skipped, 0 parsing errors**. Both targeted `CKV_AWS_394` and `CKV2_AWS_12` controls now pass. All four repository workflows passed on that commit.

This preserves the two `CKV2_AWS_5` findings as **visible, explicitly documented lab exceptions**, not fixes. Both exceptions are scoped to the exact Checkov ID and resource pair in `security/summarize_checkov.py`; a new finding or parse error fails CI. The exception owner is the repository maintainer and must be reviewed/removed before any future real workload or ENI attachment. Neither exception authorizes a production waiver. Checkov's full JSON report remains available in the GitHub Actions artifact.

**Default SG safety note:** `aws_default_security_group` adopts the default SG of the new VPC; Terraform will remove default SG rules during a real apply. That can disrupt existing workloads if copied to an already in-use VPC, so this change is intended only for the new lab VPC (and is not deployed here).

**Zone ID portability note:** The default `use1-az1`/`use1-az2` IDs are for `us-east-1`. Users must select two supported zone IDs if they change `aws_region`; the CI mock cannot confirm real AWS account AZ availability.

## Findings triage

The full Checkov scan's actual finding IDs and resource locations should be taken from the generated `aws-vpc-terraform-checkov-report` artifact on PR and main workflows. At creation, this document does **not** claim that every scanner finding is remediated or that the repository is free of security problems.

Any future exception should be documented by check ID, relevant resource, risk, decision maker, rationale, expiration/review date, and compensating control. Do not add broad ignore patterns simply to turn CI green.

## Why this is a staged gate

The Checkov scanner produces an unmodified complete report, and its JSON result is then compared to the **two explicit accepted lab exceptions**. Any unexpected issue or parsing error fails the build. In addition, the previously remediated `CKV_AWS_394` and `CKV2_AWS_12` checks have a dedicated Checkov hard gate, and `policy_gate.py` blocks a narrow set of security regressions. A passing scan still does not verify AWS account settings or actual network exposure; do not describe it as a security clearance.

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
