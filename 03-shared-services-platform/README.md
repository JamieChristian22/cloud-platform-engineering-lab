# AWS Shared Services Platform

## Project Overview

This project demonstrates an enterprise-style AWS Shared Services Platform designed to provide reusable cloud services for multiple workloads and application teams.

The platform includes shared networking, private DNS, secure remote access, secrets management, certificate management, container registry services, centralized logging, backup strategy, IAM roles, security documentation, and operational runbooks.

## Business Problem

Enterprise cloud teams need a centralized set of shared services that application teams can reuse. Without shared services, every team may create inconsistent logging, secrets, container registries, backup policies, DNS standards, and administrative access methods.

This creates duplicate infrastructure, weak governance, security inconsistencies, poor operational visibility, higher cost, harder troubleshooting, and slower application delivery.

## Solution

Designed and implemented a Shared Services Platform using AWS services that support centralized platform operations.

## Services Implemented

| Area | AWS Service | Purpose |
|---|---|---|
| Networking | Amazon VPC | Shared services network foundation |
| DNS | Route 53 Private Hosted Zone | Internal DNS namespace |
| Remote Access | AWS Systems Manager | Secure administration without bastion hosts |
| Secrets | AWS Secrets Manager | Centralized credential storage |
| Certificates | AWS Certificate Manager | Certificate lifecycle workflow |
| Containers | Amazon ECR | Private container registry |
| Logging | CloudWatch Log Groups | Centralized logging |
| Backup | AWS Backup | Backup vault, backup plan, and resource assignment |
| Identity | IAM Roles | Shared services access model |

## Architecture Summary

The environment uses a Shared Services VPC:

- VPC CIDR: `10.10.0.0/16`
- Public subnet: `10.10.1.0/24`
- Private subnet: `10.10.2.0/24`
- Internet Gateway for public subnet connectivity
- Public route table for internet egress
- Security group for controlled access

Shared platform services include Systems Manager, Secrets Manager, ACM, ECR, CloudWatch Log Groups, and AWS Backup.

## Screenshot Evidence

Screenshots should be placed in the `screenshots/` folder only after reviewing them for account identifiers, credentials, tokens, sensitive browser details, and resource metadata. A redacted illustrative replacement is provided for the former Secrets Manager secret-value view; the historical screenshot was withdrawn from the current branch.

Required screenshots:

- 01-shared-services-vpc.png
- 02-public-subnet.png
- 03-private-subnet.png
- 04-public-ip-enabled.png
- 05-internet-gateway-created.png
- 06-internet-gateway-attached.png
- 07-route-table-created.png
- 08-public-route-added.png
- 09-route-table-association.png
- 10-shared-security-group.png
- 11-managed-node.png
- 12-ssm-role-created.png
- 13-instance-profile.png
- 14-managed-node-online.png
- 15-session-manager-connected.png
- 16-secret-created.png
- [17-secret-value-redacted.svg](screenshots/17-secret-value-redacted.svg) — privacy-safe illustration (not a live AWS console screenshot)
- 18-certificate-requested.png
- 19-ecr-repository-created.png
- 20-ecr-push-commands.png
- 21-application-log-group.png
- 22-security-log-group.png
- 23-platform-log-group.png
- 24-all-log-groups.png
- 25-log-retention.png
- 26-backup-vault-created.png
- 27-backup-plan-created.png
- 28-backup-resource-assignment.png
- 29-backup-plan-summary.png
- 30-recovery-point-created.png

## Skills Demonstrated

- Platform engineering
- Shared services design
- AWS networking
- Secure systems administration
- Secrets management
- Certificate management
- Container registry management
- Centralized logging
- Backup and disaster recovery
- IAM role design
- Operations documentation
- Enterprise architecture

## Cleanup Notes

To reduce costs, stop or terminate any EC2 instances after screenshots, review AWS Backup recovery points, delete demo secrets if no longer needed, delete unused ECR repositories, and keep documentation/screenshots for GitHub evidence.
