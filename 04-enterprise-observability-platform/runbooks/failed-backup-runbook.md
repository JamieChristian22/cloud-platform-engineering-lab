# Failed Backup Runbook

## Trigger

AWS Backup job failure or missing recovery point.

## Impact

Failed backups may reduce disaster recovery readiness.

## Investigation Steps

1. Open AWS Backup.
2. Review Backup Jobs.
3. Open the failed job.
4. Review error message.
5. Confirm backup vault exists.
6. Confirm backup plan exists.
7. Confirm resource assignment exists.
8. Review IAM service role.
9. Review CloudTrail for backup-related API errors.

## Remediation Steps

- Retry the backup job.
- Validate IAM role permissions.
- Confirm the target resource still exists.
- Confirm backup vault is available.
- Update the backup plan if configuration drift occurred.

## Validation

- Backup job completes successfully.
- Recovery point appears in the backup vault.
- Retention policy is correct.

## Escalation

Escalate to Cloud Operations if backup failures continue.
