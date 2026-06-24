# CloudWatch Alarm

## Alarm Name

`enterprise-high-cpu-alarm`

## Metric

EC2 CPUUtilization

## Threshold

Greater than 70%

## Period

5 minutes

## Notification

SNS topic: `enterprise-alerts`

## Purpose

The alarm provides proactive notification when the EC2 workload experiences high CPU usage.
