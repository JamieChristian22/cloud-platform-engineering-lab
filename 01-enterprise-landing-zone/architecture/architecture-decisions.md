# Architecture decisions — current Terraform design

## Scope: one AWS account, not an organizational landing zone

This lab uses one VPC (`10.0.0.0/16` default) with two public and two private subnets across two available AZs. It is an instructional landing-zone *foundation*; there is no AWS Organizations/Control Tower, cross-account identity, SCP or shared-services account.

## NAT gateway is off by default

Private subnet internet egress is absent unless `enable_nat_gateway=true`. When enabled, **one** NAT in the first public subnet provides egress, which is cheaper but not availability-zone redundant. A production architecture needs per-AZ egress/VPC endpoints based on risk and cost.

## Public HTTP demonstration

The EC2 Apache instance runs in the first public subnet to make a smoke test possible. HTTP port 80 is open to the internet, and IPv4 egress is broad. This is a **disposable lab pattern**, not a model for a sensitive workload. Adopt TLS with an ALB and private compute for production.

## Identity without inbound SSH

The instance has an IAM role attached to `AmazonSSMManagedInstanceCore`, requires IMDSv2 and uses encrypted gp3 storage. There is no inbound SSH ingress and no managed IAM user groups. Operator Session Manager permissions are managed outside this repository.

## Audit, alerting and encryption

CloudTrail is multi-region with log-file validation and S3/KMS encryption. VPC Flow Logs target encrypted CloudWatch Logs. The S3 bucket denies non-TLS traffic and does not allow force destruction. SNS is encrypted with a customer-managed key permitting CloudWatch Alarms service use. **Live AWS log and email delivery remains to be tested.**

## Cost/governance decisions

AWS Budgets sends forecasted notifications (defaults: $25, 50/80/100%). Budgets are not account spending limits. S3 current-version lifecycle expiration is set to 365 days for demonstration; legal hold, noncurrent versions, and compliance retention are not addressed.

## Evidence and changes

The PNG architecture diagram and older manual screenshots may depict an earlier one-public/one-private subnet environment. Treat source code and [validation matrix](../docs/VALIDATION_MATRIX.md) as authoritative; update/replace legacy imagery only after verified deployment.
