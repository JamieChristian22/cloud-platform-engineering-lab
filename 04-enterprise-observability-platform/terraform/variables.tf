variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "sns_topic_name" {
  description = "SNS topic for operational alerts"
  type        = string
  default     = "enterprise-ops-alerts"
}

variable "dashboard_name" {
  description = "CloudWatch dashboard name"
  type        = string
  default     = "Enterprise-Platform-Operations"
}
