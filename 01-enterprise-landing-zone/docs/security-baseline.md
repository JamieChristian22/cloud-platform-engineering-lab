# Security Baseline

## Identity and Access Management

IAM groups were created to separate user responsibilities.

| Group | Policy | Purpose |
|---|---|---|
| enterprise-admins | AdministratorAccess | Full cloud administration |
| enterprise-engineers | PowerUserAccess | Engineering access without full IAM control |
| enterprise-auditors | ReadOnlyAccess | Audit and review access |

## Network Security

The VPC uses public/private segmentation.

### Public Subnet
Used for internet-facing workloads such as the EC2 web server.

### Private Subnet
Reserved for future internal resources such as databases, private services, and application tiers.

## Security Group Rules

Inbound:
- HTTP 80 from anywhere for web access
- HTTPS 443 from anywhere for future secure web access
- SSH 22 from My IP only for administration

Outbound:
- All traffic allowed for package installation and updates

## Logging

CloudTrail is enabled to capture management events.

## Audit Readiness

CloudTrail logs are sent to S3, supporting investigation and compliance reviews.

## Security Improvements for Future Versions

- Replace SSH with AWS Systems Manager Session Manager
- Add AWS Config rules
- Add GuardDuty
- Add VPC Flow Logs
- Add least-privilege custom IAM policies
- Add private workload tier
