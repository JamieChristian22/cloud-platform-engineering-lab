# Cost controls — canonical Terraform

- AWS Budget alerts at 50/80/100% of `monthly_budget_usd` (default $25). **Alerts do not cap AWS charges.**
- `enable_nat_gateway=false` by default prevents provisioning a billed NAT gateway. Enabling one is an explicit cost and single-AZ availability tradeoff.
- Demo EC2 instance defaults to `t3.micro`; do not assume free-tier eligibility.
- Public IPv4, EBS, AWS KMS keys, CloudWatch Logs, metrics, S3 and CloudTrail may generate charges.
- S3 audit data has versioning, a 365-day current-version expiration and `force_destroy=false`; retained objects can outlive Terraform destroy and incur charges.
- Record actual cost after AWS Billing is checked, not as estimated savings.

Review `terraform plan`, billable resource inventory and region-specific pricing before deploying. Teardown is interactive and must be followed by a residual-resource and billing review.
