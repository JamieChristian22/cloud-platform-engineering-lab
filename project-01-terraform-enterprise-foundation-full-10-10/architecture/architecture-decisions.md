# Architecture Decisions

## Reusable Modules
Networking, security, compute, and monitoring are separated into reusable modules.

## Environment Separation
Dev, test, and prod folders mirror enterprise deployment practices.

## Local State for Lab
Local Terraform state is used for simplicity. Production should use S3 remote state and DynamoDB locking.

## Monitoring Included
SNS and CloudWatch are included to demonstrate operational readiness.

## Security Considerations
SSH is configurable with `ssh_allowed_cidrs`. For real production, restrict to your IP or use Systems Manager Session Manager.
