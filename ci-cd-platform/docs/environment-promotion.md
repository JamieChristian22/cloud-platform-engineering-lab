# Environment Promotion Strategy

## Promotion Flow

```text
feature branch -> pull request -> dev -> staging -> production
```

## Dev

Used for rapid validation. Automated deployment is acceptable.

## Staging

Used for pre-production testing. Requires review and successful validation.

## Production

Requires manual approval, rollback plan, monitoring confirmation, and security checks.

## Required Before Production

- Pull request approved
- Terraform validation successful
- Secret scan passed
- IaC security review passed
- Container scan passed if Docker is used
- Rollback plan confirmed
- Monitoring dashboard available
- Alerts configured
