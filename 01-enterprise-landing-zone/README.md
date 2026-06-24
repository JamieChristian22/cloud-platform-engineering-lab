# AWS Enterprise Landing Zone

## Project Overview

This project demonstrates a secure AWS Enterprise Landing Zone built for a cloud platform engineering portfolio. The environment includes networking, identity governance, compute, logging, monitoring, alerting, and cost governance.

The goal is to show how an organization can build a basic cloud foundation before deploying production workloads.

## Business Problem

A growing organization needs a secure AWS foundation where teams can deploy cloud workloads while maintaining access control, audit visibility, operational monitoring, and cost protection.

Without a landing zone, the company risks:
- Poor network segmentation
- Uncontrolled user permissions
- Lack of audit logs
- Weak monitoring
- Unexpected AWS charges
- Inconsistent cloud operations

## Solution

Designed and deployed an AWS landing zone using:
- Amazon VPC
- Public and private subnets
- Internet Gateway
- Route table
- Security group
- EC2 Linux web server
- IAM governance groups
- CloudTrail audit logging
- S3 log storage
- CloudWatch alarm
- SNS email notification
- AWS Budget cost alerting

## Architecture

The environment contains one VPC using the CIDR block `10.0.0.0/16`.

Inside the VPC:
- Public subnet: `10.0.1.0/24`
- Private subnet: `10.0.2.0/24`
- EC2 web server deployed in the public subnet
- Security group controlling inbound and outbound traffic
- Public route table with default route to the Internet Gateway

Outside the workload layer:
- IAM groups provide role-based access governance
- CloudTrail captures management activity
- CloudWatch monitors EC2 CPU utilization
- SNS sends alert notifications
- AWS Budgets tracks monthly cost usage

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon VPC | Network foundation |
| Subnets | Public/private segmentation |
| Internet Gateway | Internet connectivity |
| Route Tables | Traffic routing |
| Security Groups | Instance-level firewall rules |
| Amazon EC2 | Linux web workload |
| IAM | Access governance |
| CloudTrail | Audit logging |
| Amazon S3 | CloudTrail log storage |
| CloudWatch | Monitoring |
| SNS | Alert notifications |
| AWS Budgets | Cost governance |

## Implementation Summary

1. Created AWS Budget for cost protection.
2. Created enterprise VPC.
3. Created public and private subnets.
4. Attached Internet Gateway.
5. Configured public route table.
6. Created web security group.
7. Created IAM governance groups.
8. Launched EC2 web server.
9. Connected using SSH key pair.
10. Installed Apache.
11. Verified website from public IP.
12. Enabled CloudTrail.
13. Created SNS topic and email subscription.
14. Created CloudWatch CPU alarm.
15. Created architecture diagram.
16. Documented design, operations, security, and lessons learned.

## Security Controls

- SSH restricted to administrator IP
- HTTP allowed for web testing
- IAM groups separated by job function
- CloudTrail enabled for audit visibility
- Security group attached only to workload instance
- Private subnet reserved for internal resources

## Monitoring and Alerting

CloudWatch monitors EC2 CPU utilization. If CPU utilization exceeds 70%, CloudWatch sends an alert to the SNS topic `enterprise-alerts`, which emails administrators.

## Logging and Auditing

CloudTrail is enabled as a multi-region trail and sends logs to an S3 bucket. This supports audit readiness and operational investigation.

## Cost Governance

AWS Budget `enterprise-budget` tracks estimated monthly charges with alert thresholds:
- 50%
- 80%
- 100%

## Evidence

Screenshots should be stored in the `screenshots/` folder.

Required screenshots:
- Budget created
- VPC created
- Public subnet
- Private subnet
- Internet Gateway attached
- Route table
- Security group
- IAM groups
- EC2 running
- SSH connected
- Apache installed
- Website working
- CloudTrail enabled
- SNS topic/subscription
- CloudWatch alarm
- Architecture diagram

## Skills Demonstrated

- AWS cloud networking
- Platform engineering
- IAM governance
- Linux administration
- Cloud monitoring
- Cloud logging
- Alerting
- FinOps
- Architecture documentation
- Operational readiness

## Cleanup

After capturing screenshots:
1. Stop or terminate EC2 instance.
2. Keep documentation and screenshots.
3. Keep budget alerts enabled.
4. Review any active AWS resources to avoid charges.

## Portfolio Rating

This project is a 10/10 entry-level cloud platform engineering project because it demonstrates real hands-on deployment, governance, security, observability, and documentation.
