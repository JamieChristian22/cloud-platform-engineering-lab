# Unauthorized API Activity Runbook

## Trigger

CloudTrail event showing:

- AccessDenied
- UnauthorizedOperation
- ConsoleLogin failure
- Suspicious IAM activity

## Impact

Unauthorized API activity may indicate misconfigured permissions, attempted misuse, or compromised credentials.

## Investigation Steps

1. Open CloudTrail Event History.
2. Filter by IAM or affected service.
3. Identify user, role, or service principal.
4. Review source IP address.
5. Review event time.
6. Review error code.
7. Check IAM permissions.
8. Review AWS Config compliance status.

## Remediation Steps

- Disable or rotate compromised credentials.
- Remove unnecessary permissions.
- Enforce MFA if missing.
- Update IAM policies.
- Review recent access key usage.
- Notify Security Team.

## Validation

- No additional unauthorized activity observed.
- IAM permissions reviewed.
- CloudTrail confirms normal activity.
- Security team acknowledges closure.

## Escalation

Escalate immediately if activity appears malicious or involves privileged access.
