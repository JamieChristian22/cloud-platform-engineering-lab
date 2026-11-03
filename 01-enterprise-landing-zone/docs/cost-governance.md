# Cost governance (design, not a billing claim)

The canonical Terraform configuration provisions a **monthly AWS Budget (default $25)** with forecasted alerts at 50%, 80% and 100%, sent to `notification_email`. A budget alerts but never blocks charges.

The most important lab control is `enable_nat_gateway = false` by default. Enabling the single NAT gateway adds hourly and traffic processing charges and introduces an availability dependency. Disabling it leaves private subnets without general internet egress.

Other possible costs include public IPv4 address usage, EC2, gp3 EBS, KMS keys/API requests, CloudWatch Logs and metrics, S3 versioned logs and transitions, CloudTrail features, and data transfer. Check the live AWS pricing page for the selected region; do not assume an instance qualifies for free tier.

After any hands-on deployment, perform a deliberate teardown review. The audit S3 bucket is not force-destroyed; versioned objects may remain and continue to cost money. Record the real budget, actual duration, observed charges and any cost exceptions only after consulting AWS Billing/Cost Explorer.
