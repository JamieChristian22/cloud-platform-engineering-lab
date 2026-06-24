# Security Findings

## Current Controls

- IAM groups created
- SSH restricted to My IP
- CloudTrail enabled
- Security group configured
- Public/private subnets separated

## Risk Notes

- EC2 is public for demonstration purposes
- HTTP is unencrypted
- AdministratorAccess is broad and should be tightly controlled in production

## Recommended Improvements

- Add Systems Manager Session Manager
- Add HTTPS certificate
- Add AWS Config
- Add GuardDuty
- Add custom IAM policies
