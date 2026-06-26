# High CPU Runbook

## Trigger

CloudWatch alarm:

`enterprise-high-cpu-alarm`

## Impact

High CPU may cause slow application response, failed requests, or service instability.

## Investigation Steps

1. Open CloudWatch Dashboard.
2. Review CPUUtilization trend.
3. Review NetworkIn and NetworkOut.
4. Check EC2 Status Checks.
5. Review application logs.
6. Run Logs Insights error query.
7. Review recent CloudTrail activity for EC2 changes.

## Remediation Steps

- Restart application service if applicable.
- Restart EC2 instance through Systems Manager Automation if approved.
- Scale resources if this is a production workload.
- Investigate application process behavior.
- Review recent deployments or configuration changes.

## Validation

- CPU returns below threshold.
- CloudWatch alarm returns to OK.
- Application health check passes.
- Logs show no repeated errors.

## Escalation

Escalate to Platform Engineering or Application Owner if CPU remains high after remediation.
