# Cloud security baseline and exceptions

## Implemented in the canonical Terraform source

- **Instance administration:** SSM-managed EC2 IAM instance profile; no inbound TCP/22. Verify the SSM agent can reach the service and the operator has authorized Session Manager access.
- **Compute:** IMDSv2 required, encrypted gp3 root volume, explicitly attached VPC security group.
- **Network:** segmented public/private subnets across two availability zones. Public HTTP/80 serves a demo only; all outbound traffic is currently permitted for bootstrapping/SSM and requires reduction for production.
- **Storage:** audit S3 bucket private/public access blocked, versioning enabled, SSE-KMS configured and force-destroy disabled. Bucket policy denies non-TLS requests and restricts CloudTrail service requests to the expected trail ARN.
- **Audit:** multi-region CloudTrail and VPC Flow Logs configured. Customer-managed KMS policy grants CloudTrail/CloudWatch Logs narrowly defined service permissions.
- **Notifications:** CloudWatch/SNS alert encryption uses a separate KMS key with service principal grants, not the default SNS AWS-managed key.
- **Safety:** NAT gateway is opt-in; budget alerts do not prevent AWS charges.

## Important exclusions / open risks

This is **not** a multi-account AWS landing zone, and no Control Tower, organization policy, SCP or AWS Config/GuardDuty organization rollout is implemented. The EC2 demo is directly public on HTTP with no TLS or load balancer; do not expose personal or confidential data. The single NAT option is a single-AZ dependency. Audit retention is a configurable organizational decision, not proof of compliance (current version expires after 365 days; noncurrent versions can remain).

The code does **not** prove that live CloudTrail/SNS/KMS integration, IAM access, image patching, log delivery, alerts or subnet egress behave correctly. Follow [the evidence matrix](VALIDATION_MATRIX.md).

## Before adapting for production

Use isolated multi-account structure with organizational guardrails, IAM Identity Center, workload/private ingress behind TLS, multiple NAT gateways or network endpoints, selective egress, explicit log retention and access reviews, tests of alarm publication, and cost/availability modeling. Run Checkov/TFLint alongside pinned-action CI checks and review exceptions rather than suppressing failures without explanation.
