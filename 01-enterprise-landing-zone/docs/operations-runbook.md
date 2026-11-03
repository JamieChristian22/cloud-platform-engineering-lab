# AWS landing-zone operations runbook

Commands below are **instructions**, not records of successful execution. Use a sandbox account and replace identifiers from the **current** Terraform outputs. Never publish raw Terraform state or sensitive AWS response fields.

## Before checks

```bash
aws sts get-caller-identity
terraform -chdir=terraform/terraform output
```

Confirm the account and region are expected. Save UTC timestamp, git SHA, Terraform version, exact command, exit code and sanitized evidence per [evidence guide](../evidence/deployment-evidence.md).

## EC2 health and web endpoint

Obtain `web_public_ip` and `web_url` from Terraform outputs; find the instance ID through EC2 by tag. Inspect instance health in AWS EC2, then run `make test`. On the instance, the bootstrap installs Apache and enables `httpd`. A successful HTTP response establishes only **application reachability**, not TLS or production readiness.

## Session Manager (no SSH)

Use the AWS console EC2 **Connect > Session Manager** (authorized users only), or:

```bash
aws ssm start-session --target INSTANCE_ID
```

The instance must have the SSM agent, profile, outbound service reachability and an operator identity permitted to start a session. No SSH key pair or inbound port 22 is configured.

## Audit logging and flow logs

```bash
aws cloudtrail describe-trails
aws cloudtrail get-trail-status --name TRAIL_NAME
aws ec2 describe-flow-logs --filter Name=resource-id,Values=VPC_ID
aws logs describe-log-groups --log-group-name-prefix /aws/vpc/
```

Confirm delivery **to the expected encrypted S3/CloudWatch destinations**, not merely resource creation. Examine KMS access errors in CloudTrail and CloudWatch Logs if logging fails. Audit objects are intentionally protected from forced Terraform destruction.

## Alert delivery

```bash
aws cloudwatch describe-alarms --alarm-names ALARM_NAME
aws sns list-subscriptions-by-topic --topic-arn TOPIC_ARN
```

Confirm the email subscription has been manually accepted. Test alarm delivery in a nonproduction account and verify notifications are actually received; this requires the SNS KMS key service permissions. Return an artificially changed alarm state to normal if you use a test alarm mechanism.

## Cost controls and teardown

A budget is an alert, **not** a spending cap. Public IPv4, KMS, and other services may incur charges even with NAT disabled; if NAT is enabled, it incurs additional ongoing fees. `make destroy` prompts and may leave an intentionally protected log bucket; review resources and billing after the teardown. A suspended EC2 instance is not the same as deleting all billable storage or addresses.
