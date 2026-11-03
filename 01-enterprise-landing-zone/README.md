# AWS Enterprise Landing Zone — Terraform & Kubernetes Lab

An **AWS single-account, production-inspired lab**, not a fully governed multi-account enterprise landing zone or verified production deployment. This project models VPC networking, a public demonstration web workload, SSM-based administration, audit logging, alerts, budget controls and a separately deployable Kubernetes workload layer.

## Start here

- [Canonical Terraform root](terraform/terraform/) — the **only** Terraform configuration used by the project scripts.
- [Validation matrix and evidence standards](docs/VALIDATION_MATRIX.md)
- [Architecture decisions](architecture/architecture-decisions.md)
- [Kubernetes workload layer](kubernetes/README.md) — requires an existing Kubernetes cluster; this Terraform does **not** provision EKS.
- [Operational scripts](scripts/)

## Architecture in code

Two public and two private subnets in a single VPC, two availability zones, **one** NAT gateway, an EC2 Apache demo server in a public subnet, IAM instance profile for AWS Systems Manager, S3/CloudTrail audit storage, VPC Flow Logs, CloudWatch/SNS alerts and an AWS Budget.

**Tradeoffs:** one NAT gateway creates an availability dependency; the demo server uses HTTP rather than HTTPS; this is not a multi-account AWS Organizations landing zone. Kubernetes manifests are a separate workload example, not a deployed cluster.

## Local validation (no AWS deployment)

Prerequisites: Python 3.11+, Terraform 1.7+, AWS provider download access for Terraform validation.

```bash
python -m unittest discover -s tests -v
make validate
cd kubernetes && ./scripts/validate.sh
```

`make validate` runs Terraform formatting, init without backend, and validate against `terraform/terraform`. Optional tflint/checkov/shellcheck run when installed. Validation is not a substitute for a cloud deployment.

## Deployment — creates billable AWS resources

Use a sandbox account with budget alerts. AWS authentication and appropriate IAM permissions are required.

```bash
cp terraform/terraform/terraform.tfvars.example terraform/terraform/terraform.tfvars
# Edit notification_email and other variables; do not commit the tfvars.
make bootstrap
make plan
# Review terraform/terraform/tfplan locally before approving.
make deploy
make test
```

The apply script requires an existing plan and does **not** use `-auto-approve`. Terraform plans and state can contain secrets and must never be committed. Confirm SNS email subscriptions separately. `make destroy` prompts before destruction; the audit bucket is protected from force-destruction and may need separate retention-aware cleanup.

## Evidence and claims

Historical screenshots and older manual instructions describe a **different, simpler** configuration and should not be used as proof that this canonical Terraform configuration was deployed. See [validation matrix](docs/VALIDATION_MATRIX.md) for required live evidence. Existing narrative claims are educational and not current execution attestations.

## Security notes

- No public SSH ingress in the canonical configuration. Manage EC2 with Systems Manager Session Manager when available.
- S3 audit bucket blocks public access and does not force-delete objects.
- EC2 requires IMDSv2 and encrypted root storage.
- Audit KMS key access, CloudTrail delivery, and log retention before using this design beyond a lab.
- The example notification email is a placeholder. Never commit secrets or state.

## License

See the repository [LICENSE](../LICENSE) and third-party asset rights documentation.
