# Canonical Terraform implementation guide

This replaces the older one-subnet, SSH/key-pair console tutorial. **Only `terraform/terraform/` is an active Terraform root.** The neighboring `networking/`, `compute/` and `screenshots/` folders are historical learning notes, not a deployment contract.

## Prerequisites and risk

- Terraform >= 1.7, Python >= 3.11, AWS CLI v2, secure AWS authentication, appropriate IAM permissions, and an isolated sandbox account.
- Review service pricing before proceeding. EC2, NAT (when enabled), CloudTrail/S3/KMS, CloudWatch and public IPv4 can create costs. An AWS Budget **alerts** but does not cap charges.
- Use an encrypted and access-controlled Terraform backend with state locking for shared work; do not commit `terraform.tfstate`, `tfplan`, credentials or real `terraform.tfvars`.
- If an older configuration is already applied, do not move resources to a new root without an explicit state migration and reviewed plan.

## Steps

```bash
cp terraform/terraform/terraform.tfvars.example terraform/terraform/terraform.tfvars
# Replace notification_email, review aws_region and monthly_budget_usd.
# enable_nat_gateway=false avoids a billed NAT gateway.
python3 -m unittest discover -s tests -v
make validate
make bootstrap
aws sts get-caller-identity
make plan
```

Review all planned resources, charges, IAM/KMS permissions, and the change summary. **Only apply if the plan is expected and the account is isolated.**

```bash
make deploy
make test
```

After apply, independently verify CloudTrail delivery into S3, VPC Flow Logs, the SSM connection, encrypted SNS alarm delivery and confirmed email subscription. See [operations runbook](operations-runbook.md) and [validation matrix](VALIDATION_MATRIX.md). The script completing is **not** proof all AWS service integrations work.

## Cleanup

`make destroy` is interactive and may stop because the audit bucket is deliberately protected by `force_destroy=false`. Make a retention-aware decision and perform explicit deletion only if authorized. Watch for residual buckets, log groups, KMS keys, public IPv4 or other resources, and review billing.

## Kubernetes

`kubernetes/` is an **independent workload sample**, not an EKS cluster. `cd kubernetes && ./scripts/validate.sh` verifies overlay rendering. Any actual `kubectl apply` requires a separately managed cluster and acceptance review.
