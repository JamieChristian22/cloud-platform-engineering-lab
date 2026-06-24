# Lessons Learned

## What Was Built

- AWS VPC foundation
- Public/private subnet design
- Internet gateway and route table
- EC2 Linux web server
- Apache web application
- IAM governance groups
- CloudTrail audit logging
- SNS alerting
- CloudWatch monitoring
- AWS Budget cost governance

## Technical Lessons

- VPCs provide isolated network environments.
- Public subnets require a route to an Internet Gateway.
- Private subnets are useful for internal-only resources.
- Security groups act as virtual firewalls.
- IAM groups support role-based access.
- CloudTrail helps with auditing and incident review.
- CloudWatch provides operational metrics.
- SNS enables alert delivery.
- AWS Budgets support financial governance.

## Portfolio Lessons

This project is stronger when it includes:
- Screenshots
- Diagram
- Documentation
- Troubleshooting notes
- Security explanation
- Cost explanation
- Operational runbook

## Future Improvements

- Add Terraform automation
- Add AWS Config
- Add GuardDuty
- Add VPC Flow Logs
- Add private application tier
- Add Systems Manager instead of SSH
- Add CI/CD deployment workflow
