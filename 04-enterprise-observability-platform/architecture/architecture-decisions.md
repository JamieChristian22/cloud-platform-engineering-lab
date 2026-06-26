# Architecture Decisions

## Decision 1: CloudWatch as the Core Observability Service

Amazon CloudWatch was selected as the central monitoring and observability service because it provides metrics, alarms, dashboards, logs, and query capabilities.

## Decision 2: SNS for Alert Delivery

Amazon SNS was selected to deliver operational alerts to platform administrators.

## Decision 3: CloudTrail for Audit Visibility

CloudTrail provides account-level API activity tracking. It is required for investigating changes, unauthorized access attempts, and administrative actions.

## Decision 4: AWS Config for Compliance Monitoring

AWS Config was added to continuously record resource configuration and evaluate compliance rules.

## Decision 5: Systems Manager Automation for Remediation

Systems Manager Automation demonstrates how platform teams automate common operational tasks, such as restarting an EC2 instance.

## Decision 6: Runbooks for Operational Consistency

Runbooks ensure incidents are handled consistently. They define alert triggers, investigation steps, remediation actions, validation, and post-incident review.

## Decision 7: Backup Visibility

AWS Backup is included because operational platforms must monitor backup posture and recovery readiness.

## Future Architecture Enhancements

- Add Amazon EventBridge for event-driven remediation.
- Add AWS X-Ray for distributed tracing.
- Add Amazon Managed Grafana.
- Add OpenSearch for centralized log analytics.
- Add cross-account CloudWatch dashboards.
- Add Security Hub findings into dashboards.
