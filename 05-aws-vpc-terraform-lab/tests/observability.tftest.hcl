# Mock provider: Terraform tests do not call AWS.
mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = ["us-east-1a", "us-east-1b", "us-east-1c"]
    }
  }
}

run "monitoring_disabled_by_default" {
  command = plan

  assert {
    condition     = var.enable_flow_logs == false
    error_message = "Optional CloudWatch monitoring must be disabled by default."
  }

  assert {
    condition     = length(aws_flow_log.vpc) == 0 && length(aws_cloudwatch_log_group.vpc) == 0 && length(aws_cloudwatch_metric_alarm.rejected) == 0
    error_message = "Default configuration must not propose paid monitoring resources."
  }
}

run "opt_in_monitoring_resources" {
  command = plan
  variables {
    enable_flow_logs = true
  }

  assert {
    condition     = length(aws_flow_log.vpc) == 1 && length(aws_cloudwatch_log_group.vpc) == 1 && length(aws_cloudwatch_metric_alarm.rejected) == 1
    error_message = "Opt-in should plan one flow log, log group and rejected-flow alarm."
  }

  assert {
    condition     = aws_flow_log.vpc[0].traffic_type == "ALL" && aws_flow_log.vpc[0].log_destination_type == "cloud-watch-logs"
    error_message = "Flow logs must monitor all traffic and be destined for CloudWatch Logs."
  }

  assert {
    condition     = aws_cloudwatch_log_group.vpc[0].retention_in_days == 7
    error_message = "The default log retention must be seven days."
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.rejected[0].threshold == 5 && aws_cloudwatch_metric_alarm.rejected[0].period == 300
    error_message = "The baseline alert must detect five rejected flow records per five minutes."
  }
}
