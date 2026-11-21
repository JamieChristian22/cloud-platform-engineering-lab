# Shared Services Terraform — Network Security Controls

This is a **source-only training module** under `03-shared-services-platform/terraform/`. Its check results are not evidence that AWS infrastructure has been deployed.

## Security changes and what they mean

- `aws_subnet.public.map_public_ip_on_launch = false`: new instances launched in this subnet no longer automatically receive public IPv4 addresses. It is still a *public subnet* because its route table points to the internet gateway. An explicit, approved public-IP workflow would be required for a public workload.
- `aws_route_table.private` and `aws_route_table_association.private`: keep the private subnet associated with a route table that has **no configured default route to the internet**. This intentionally prevents ordinary outbound internet access; connectivity through approved VPC endpoints or a cost-reviewed NAT design would require further work.
- `aws_default_security_group.locked_down`: manages the *automatically created default security group* for the new VPC, with no explicit ingress or egress permissions. This is a default-deny baseline for any future workload that accidentally uses the default SG. **Do not copy this into an existing production VPC without reviewing workloads that may use the default group.**
- Three existing CloudWatch Logs groups retain 30-day retention and do **not** specify a customer-managed KMS key. Service-managed encryption is not the same as a custom compliance key, and 30 days may not meet regulated retention obligations.

## Security findings deliberately left open

- `CKV2_AWS_11`: VPC Flow Logs are not enabled in this starter Terraform root; doing so creates ingestion/storage costs. Decide the log destination, retention, permissions, and budget before enabling.
- `CKV_AWS_158` (three log groups): customer-managed encryption keys are not defined. Adding KMS resources and permissions would require billing and key-policy planning.
- `CKV_AWS_338` (three log groups): 30 days of retention is below the scanner's longer-retention policy. Increasing it blindly would increase stored data; choose a real classification/retention policy first.

## Tests and evidence

The dedicated `tests/security.tftest.hcl` uses a **mock AWS provider** to simulate resource creation *in memory*. No real EC2 instances, ENIs, VPC resources, or IAM policies are created. The legacy CI matrix runs formatting, initialization and validation for this root, plus `terraform test`. The Checkov audit remains advisory for legacy policy debt but **blocks** regressions on `CKV_AWS_130` and `CKV2_AWS_12` for this exact root.

From the Terraform root (no AWS resources created):

```sh
terraform init -backend=false -input=false
terraform fmt -check -diff
terraform validate
terraform test -no-color
```

Do not use `terraform plan`, `terraform apply`, or `terraform destroy` for this learning exercise without a separately approved account and cost review.
