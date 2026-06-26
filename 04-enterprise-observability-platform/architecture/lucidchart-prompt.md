# Lucidchart AI Prompt — Enterprise Observability Platform

Create a professional AWS Enterprise Observability Platform architecture diagram.

Title:

AWS Enterprise Observability Platform

Use official AWS Architecture Icons only.

Design requirements:
- White background
- Enterprise architecture style
- Clean spacing and alignment
- Clear directional arrows
- Professional GitHub portfolio quality
- Group resources into logical sections
- Label every service and workflow

Include these major sections:

## Workload Layer

Show:

- EC2 Instance: enterprise-web-server
- Shared Services Platform
- Shared Services VPC
- Cloud Platform Resources

These resources generate metrics, logs, events, and operational signals.

## Metrics and Dashboard Layer

Show:

Amazon CloudWatch Metrics collecting:

- CPUUtilization
- NetworkIn
- NetworkOut
- StatusCheckFailed

Show metrics flowing into:

CloudWatch Dashboard:
Enterprise-Platform-Operations

Dashboard widgets:
- CPU Utilization
- Network Traffic
- Status Checks
- Alarm State
- Platform Health KPIs

## Alerting Layer

Show:

CloudWatch Alarms:

- enterprise-high-cpu-alarm
- enterprise-status-check-failed

CloudWatch Alarms send notifications to:

SNS Topic:
enterprise-ops-alerts

SNS sends email to:

Platform Engineers / Administrators

## Logging Layer

Show:

CloudWatch Logs

Shared Log Groups:

- /shared/services/application
- /shared/services/security
- /shared/services/platform

Show:

CloudWatch Logs Insights

Log queries:
- Error Search
- Unauthorized Activity
- Recent Events

## Audit Layer

Show:

AWS CloudTrail

CloudTrail Event History includes:

- EC2 API Events
- IAM API Events
- CloudWatch Events
- Systems Manager Events

CloudTrail supports:

- Security Investigation
- Audit Review
- API Activity Tracking

## Compliance Layer

Show:

AWS Config

Include:

- Configuration Recorder
- S3 Delivery Channel
- Compliance Rules
- restricted-ssh rule
- Compliance Dashboard

AWS Config monitors:
- Security Groups
- EC2
- IAM
- VPC Resources

## Automation Layer

Show:

AWS Systems Manager Automation

Automation Document:

AWS-RestartEC2Instance

Show flow:

Alarm or Operator Action → Systems Manager Automation → EC2 Remediation

## Backup Operations Layer

Show:

AWS Backup

Include:

- Backup Vault
- Backup Plan
- Recovery Points
- Backup Status Monitoring

## Incident Response Layer

Show:

Incident Response Runbooks:

- High CPU Runbook
- Failed Backup Runbook
- Unauthorized API Activity Runbook
- General Incident Response Runbook

Show runbooks connected to:
- CloudWatch Alarms
- CloudTrail
- AWS Config
- Systems Manager
- AWS Backup

## Flow Requirements

Show these flows clearly:

1. EC2 and platform services send metrics to CloudWatch.
2. CloudWatch dashboards visualize platform health.
3. CloudWatch alarms detect issues.
4. Alarms notify SNS.
5. SNS emails platform engineers.
6. CloudWatch Logs stores application, security, and platform logs.
7. Logs Insights supports troubleshooting.
8. CloudTrail records API activity.
9. AWS Config tracks compliance.
10. Systems Manager Automation remediates operational issues.
11. AWS Backup provides recovery visibility.
12. Runbooks guide incident response.

## Footer Panel

Add a footer titled:

Enterprise Operational Capabilities

Include:

- Platform Health Monitoring
- Centralized Logging
- Alerting and Notifications
- Audit Visibility
- Compliance Monitoring
- Automated Remediation
- Incident Response
- Backup Visibility
- Operational Excellence
- Cloud Platform Operations

The final diagram should look like a production-ready AWS operations and observability architecture suitable for a Cloud Engineer, Platform Engineer, DevOps Engineer, SRE, or Solutions Architect portfolio.
