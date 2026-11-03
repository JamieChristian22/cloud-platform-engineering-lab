# Project summary

**AWS Landing Zone (single-account portfolio lab)**

A repository-backed design for a segmented VPC across two availability zones, an SSM-managed Apache demo instance, encrypted CloudTrail and Flow Logs, a CPU alert to SNS and AWS Budgets. The NAT gateway is optional and off by default to reduce costs. Kubernetes dev/prod manifests demonstrate a separate workload concept; they do not provision an EKS cluster.

**Artifacts:** canonical Terraform (`terraform/terraform/`), deployment and validation scripts, Python regression tests, GitHub Actions static checks, architecture decisions, operational runbook and evidence matrix.

**Claims supported by source inspection:** infrastructure resources and policies are encoded; scripts and tests are version controlled. **Not established by documentation alone:** completed AWS apply, correct CloudTrail/KMS delivery, confirmed SNS email reception, live Kubernetes operation, cost results or production readiness. See [validation status](../evidence/validation-results.md).

**Skills represented:** Terraform/HCL, AWS networking, SSM/IAM, CloudTrail/CloudWatch/S3/KMS, security tradeoffs, reproducible testing, incident-ready runbooks, FinOps and evidence integrity.
