# Threat Model

## Assets

- Cloud identities
- Application workloads
- Storage buckets
- Logs and monitoring data
- Terraform state
- CI/CD secrets

## Threats

| Threat | Risk | Mitigation |
|---|---|---|
| Credential theft | Unauthorized access | MFA, secret scanning, rotation |
| Public data exposure | Data breach | Block public access, encryption |
| Privilege escalation | Admin compromise | Least privilege, access reviews |
| Network exposure | Attack surface expansion | Segmentation, firewall rules |
| Logging disabled | Missed detection | Mandatory audit logging |
| Pipeline compromise | Supply chain risk | Branch protection, approvals |

## Detection

- Failed login spikes
- IAM policy changes
- Public bucket changes
- Security group changes
- Disabled logging
- New admin users
