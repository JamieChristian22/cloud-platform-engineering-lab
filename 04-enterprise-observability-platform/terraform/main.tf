provider "aws" {
  region = var.aws_region
}

resource "aws_sns_topic" "ops_alerts" {
  name = var.sns_topic_name
}

resource "aws_cloudwatch_dashboard" "platform_operations" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 2
        properties = {
          markdown = "# Enterprise Platform Operations Dashboard\nCloudWatch metrics, alarms, logs, audit visibility, and operational KPIs."
        }
      }
    ]
  })
}
