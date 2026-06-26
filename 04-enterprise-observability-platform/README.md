# Enterprise Observability Platform

## Project Overview

This project demonstrates an enterprise AWS observability and operations platform. The purpose is to show how a cloud platform team monitors, alerts, audits, automates, and responds to operational issues after the cloud foundation has already been deployed.

This project builds on the previous cloud platform projects:

1. Enterprise Landing Zone
2. Multi-Account Governance Platform
3. Shared Services Platform
4. Enterprise Observability Platform

Together, these projects tell a complete cloud platform engineering story: build the foundation, govern it, provide shared services, and operate the platform.

## Business Problem

Organizations need more than deployed infrastructure. They need visibility into platform health, system performance, audit events, compliance posture, and operational incidents. Without observability, teams are reactive instead of proactive.

Common problems include:

- No centralized dashboard
- No clear alerting strategy
- Logs spread across services
- Weak incident response process
- Limited audit visibility
- Configuration drift
- Slow troubleshooting
- Manual remediation

## Solution

This project implements an AWS observability platform using:

- Amazon CloudWatch Dashboards
- CloudWatch Metrics
- CloudWatch Alarms
- CloudWatch Logs
- CloudWatch Logs Insights
- Amazon SNS
- AWS CloudTrail
- AWS Config
- AWS Systems Manager Automation
- AWS Backup operational checks
- Incident response runbooks

## Architecture Summary

The observability platform collects metrics, logs, audit events, and compliance data from AWS resources. CloudWatch dashboards provide operational visibility. CloudWatch alarms send alerts to SNS. CloudTrail supports API activity investigation. AWS Config monitors resource compliance. Systems Manager Automation supports operational remediation. Runbooks define repeatable incident response procedures.

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon CloudWatch Dashboards | Platform health visibility |
| CloudWatch Metrics | EC2 and platform performance data |
| CloudWatch Alarms | Threshold-based alerting |
| CloudWatch Logs | Centralized log storage |
| CloudWatch Logs Insights | Log query and investigation |
| Amazon SNS | Email notifications |
| AWS CloudTrail | API activity auditing |
| AWS Config | Configuration and compliance monitoring |
| AWS Systems Manager Automation | Operational remediation |
| AWS Backup | Backup and recovery visibility |

## Platform KPIs

The platform tracks:

- EC2 CPU utilization
- Network input and output
- Instance status checks
- Alarm state
- CloudTrail API events
- AWS Config compliance status
- Backup plan health
- Log query visibility
- Automation execution status

## Implementation Summary

1. Created SNS topic for operational alerts.
2. Created CloudWatch dashboard.
3. Added EC2 metrics to dashboard.
4. Created high CPU alarm.
5. Created instance status check alarm.
6. Queried logs with CloudWatch Logs Insights.
7. Reviewed CloudTrail event history.
8. Enabled AWS Config recording.
9. Added compliance rule for restricted SSH.
10. Executed Systems Manager Automation.
11. Created incident response runbooks.
12. Created architecture documentation.
13. Added Terraform starter files.
14. Organized evidence screenshots.

## Evidence Screenshots

Store screenshots in the `evidence/` folder:

- 01-sns-topic-created.png
- 02-cloudwatch-dashboard.png
- 03-high-cpu-alarm.png
- 04-status-check-alarm.png
- 05-log-insights-query.png
- 06a-cloudtrail-ec2-events.png
- 06b-cloudtrail-iam-events.png
- 06c-cloudtrail-overview.png
- 07a-config-recorder.png
- 07b-config-rule.png
- 07c-config-dashboard.png
- 08a-automation-document.png
- 08b-automation-execution.png
- 09-runbooks-folder.png
- observability-architecture.png

## Skills Demonstrated

- Cloud operations
- Observability engineering
- CloudWatch dashboards
- Metrics and alarms
- Log analysis
- AWS audit investigation
- Compliance monitoring
- Systems automation
- Incident response
- Runbook development
- Platform health monitoring
- Operational excellence

## Cleanup

To reduce cost risk:

- Disable AWS Config recorder after screenshots if not needed.
- Delete unnecessary alarms or dashboards.
- Stop EC2 instances when not in use.
- Review SNS subscriptions.
- Delete unused CloudWatch log groups if needed.

## Portfolio Value

This project demonstrates that the platform is not only deployed, but also operated. It shows skills used by Cloud Engineers, Platform Engineers, DevOps Engineers, Cloud Operations Engineers, and SREs.
