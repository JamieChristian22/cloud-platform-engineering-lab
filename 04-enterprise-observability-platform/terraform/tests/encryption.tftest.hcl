# Simulated Terraform test, no AWS calls or SNS publishing.
mock_provider "aws" {}

run "sns_topic_encrypted_by_default" {
  command = plan

  assert {
    condition     = aws_sns_topic.ops_alerts.kms_master_key_id == "alias/aws/sns"
    error_message = "The operations SNS topic must be encrypted with an AWS-managed KMS key."
  }

  assert {
    condition     = aws_sns_topic.ops_alerts.name == var.sns_topic_name
    error_message = "The topic name must follow the configured variable."
  }
}
