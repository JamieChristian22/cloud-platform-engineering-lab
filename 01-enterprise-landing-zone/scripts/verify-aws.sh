#!/usr/bin/env bash
# Optional read-only live acceptance checks; requires deployed sandbox and AWS credentials.
set -euo pipefail
export AWS_PAGER=""
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF="$ROOT/terraform/terraform"
for command_name in aws terraform; do
  command -v "$command_name" >/dev/null || { echo "Missing CLI: $command_name" >&2; exit 1; }
done
account="$(aws sts get-caller-identity --query Account --output text)"
instance="$(terraform -chdir="$TF" output -raw web_instance_id)"
vpc="$(terraform -chdir="$TF" output -raw vpc_id)"
trail="$(terraform -chdir="$TF" output -raw cloudtrail_name)"
group="$(terraform -chdir="$TF" output -raw flow_log_group_name)"
topic="$(terraform -chdir="$TF" output -raw sns_topic_arn)"
bucket="$(terraform -chdir="$TF" output -raw audit_bucket_name)"
budget="$(terraform -chdir="$TF" output -raw monthly_budget_name)"

state="$(aws ec2 describe-instances --instance-ids "$instance" --query 'Reservations[0].Instances[0].State.Name' --output text)"
[[ "$state" == "running" ]] || { echo "FAIL: instance not running" >&2; exit 1; }
echo "PASS: instance running"

ssm="$(aws ssm describe-instance-information --filters "Key=InstanceIds,Values=$instance" --query 'InstanceInformationList[0].PingStatus' --output text)"
[[ "$ssm" == "Online" ]] || { echo "FAIL: SSM instance not online" >&2; exit 1; }
echo "PASS: SSM online"

logging="$(aws cloudtrail get-trail-status --name "$trail" --query IsLogging --output text)"
[[ "$logging" == "True" ]] || { echo "FAIL: CloudTrail not logging" >&2; exit 1; }
delivery_error="$(aws cloudtrail get-trail-status --name "$trail" --query LatestDeliveryError --output text)"
[[ "$delivery_error" == "None" || -z "$delivery_error" ]] || { echo "FAIL: CloudTrail delivery error reported" >&2; exit 1; }
echo "PASS: CloudTrail reports logging enabled"

flow="$(aws ec2 describe-flow-logs --filter "Name=resource-id,Values=$vpc" --query 'FlowLogs[0].FlowLogStatus' --output text)"
[[ "$flow" == "ACTIVE" ]] || { echo "FAIL: VPC Flow Logs not active" >&2; exit 1; }
log_group="$(aws logs describe-log-groups --log-group-name-prefix "$group" --query 'logGroups[0].logGroupName' --output text)"
[[ "$log_group" == "$group" ]] || { echo "FAIL: flow log group not found" >&2; exit 1; }
echo "PASS: flow logs and log group"

aws s3api get-bucket-encryption --bucket "$bucket" >/dev/null
aws s3api get-public-access-block --bucket "$bucket" >/dev/null
echo "PASS: S3 encryption and public access block exist"

subs="$(aws sns list-subscriptions-by-topic --topic-arn "$topic" --query 'Subscriptions[].SubscriptionArn' --output text)"
[[ -n "$subs" && "$subs" != *PendingConfirmation* ]] || { echo "FAIL: SNS subscription missing or not yet confirmed" >&2; exit 1; }
echo "PASS: SNS has subscription without pending confirmation"

aws budgets describe-budget --account-id "$account" --budget-name "$budget" >/dev/null
echo "PASS: AWS Budget exists"
echo "LIMIT: a live CloudTrail object delivery/decryption test, SNS email receipt, actual spend and teardown still require separate evidence."
