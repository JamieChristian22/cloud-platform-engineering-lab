# Cost Governance

## Budget Configuration

Budget name:

```text
enterprise-budget
```

Monthly budget amount:

```text
$5
```

Alert thresholds:
- 50%
- 80%
- 100%

Notification:
- Email alert to administrator

## Purpose

The budget was configured to reduce the risk of unexpected AWS charges and demonstrate FinOps awareness.

## Cost Controls Used

- Free-tier eligible EC2 instance type
- Small root EBS volume
- No NAT Gateway
- No load balancer
- No paid data event logging
- No CloudTrail Insights
- Budget alerting enabled
- EC2 stopped or terminated after evidence collection

## FinOps Value

This project shows that cloud engineers understand not only deployment, but also cost visibility and financial governance.
