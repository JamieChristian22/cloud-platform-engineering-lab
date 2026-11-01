# AWS Secrets Manager

## Purpose

AWS Secrets Manager provides secure storage for credentials, API keys, and application secrets.

## Secret Created

Name: `enterprise/shared/database`

Example keys:
- username
- password

## Security Note

The values used in this project are demonstration values only and should not be used for real systems.

## Enterprise Value

Secrets Manager avoids hardcoded credentials, supports IAM-controlled access, supports rotation, supports audit logging through CloudTrail, and centralizes secret management.

## Privacy and evidence status

The screenshot previously named `17-secret-value.png` has been withdrawn from the current branch because it exposed account/resource identifiers and a username, although the password was masked. The replacement is an illustrative diagram, not a direct console capture. Git history can still contain previously published files; treat public historical artifacts as potentially accessible. Review the underlying account for any real credential exposure and rotate values if necessary.

## Screenshots

- 16-secret-created.png
- [Redacted secret-value illustration](../screenshots/17-secret-value-redacted.svg) — intentionally contains no account ID, secret ARN, username, or credential
