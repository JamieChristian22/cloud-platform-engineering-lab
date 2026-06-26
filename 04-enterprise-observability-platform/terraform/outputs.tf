output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.ops_alerts.arn
}

output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.platform_operations.dashboard_name
}
