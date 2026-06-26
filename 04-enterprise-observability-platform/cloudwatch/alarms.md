# CloudWatch Alarms

## Purpose

CloudWatch alarms detect abnormal platform behavior and trigger notifications through SNS.

## Alarm 1: High CPU

Name:

`enterprise-high-cpu-alarm`

Metric:

`CPUUtilization`

Threshold:

Greater than `70%`

Action:

Notify SNS topic `enterprise-ops-alerts`.

## Alarm 2: Status Check Failed

Name:

`enterprise-status-check-failed`

Metric:

`StatusCheckFailed`

Threshold:

Greater than or equal to `1`

Action:

Notify SNS topic `enterprise-ops-alerts`.

## Enterprise Value

Alarms create proactive notification when resources enter unhealthy states.

## Screenshots

- `03-high-cpu-alarm.png`
- `04-status-check-alarm.png`
