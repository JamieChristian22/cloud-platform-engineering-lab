# OPTIONAL LIVE AWS MONITORING. Defaults to disabled.
# With enable_flow_logs=false, ALL resources in this file have count = 0.
# Enabling incurs CloudWatch Logs ingestion/storage and alarm charges.
# Do not apply without prior AWS account/cost approval.

resource "aws_cloudwatch_log_group" "vpc" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = "/aws/vpc/${var.project_name}/flow-logs"
  retention_in_days = var.flow_log_retention_days

  tags = { Name = "${var.project_name}-flow-logs" }
}

resource "aws_iam_role" "vpc_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  name_prefix = "${var.project_name}-flow-logs-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Name = "${var.project_name}-flow-logs-role" }
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.project_name}-flow-logs-delivery"
  role  = aws_iam_role.vpc_flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DescribeLogGroups"
        Effect   = "Allow"
        Action   = ["logs:DescribeLogGroups"]
        Resource = "*"
      },
      {
        Sid    = "WriteToSelectedLogGroup"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          aws_cloudwatch_log_group.vpc[0].arn,
          "${aws_cloudwatch_log_group.vpc[0].arn}:*"
        ]
      }
    ]
  })
}

resource "aws_flow_log" "vpc" {
  count                = var.enable_flow_logs ? 1 : 0
  vpc_id               = aws_vpc.lab.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc[0].arn
  iam_role_arn         = aws_iam_role.vpc_flow_logs[0].arn
  depends_on           = [aws_iam_role_policy.vpc_flow_logs]

  tags = { Name = "${var.project_name}-vpc-flow-logs" }
}

resource "aws_cloudwatch_log_metric_filter" "rejected" {
  count          = var.enable_flow_logs ? 1 : 0
  name           = "${var.project_name}-rejected-flows"
  log_group_name = aws_cloudwatch_log_group.vpc[0].name
  pattern        = "[version, account, interface, srcaddr, dstaddr, srcport, dstport, protocol, packets, bytes, start, end, action = REJECT, log_status]"

  metric_transformation {
    name          = "RejectedFlowRecords"
    namespace     = "CloudPlatformLab/VPC"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "rejected" {
  count               = var.enable_flow_logs ? 1 : 0
  alarm_name          = "${var.project_name}-rejected-flows-burst"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RejectedFlowRecords"
  namespace           = "CloudPlatformLab/VPC"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_description   = "Five or more REJECT flow records in five minutes; investigate context before escalation."
  # No alarm_actions are configured: this learning module sends no alerts.

  tags = { Name = "${var.project_name}-rejected-flows-burst" }
}
