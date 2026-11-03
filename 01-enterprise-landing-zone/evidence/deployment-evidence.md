# Evidence collection guide

Historical screenshots are not proof of the current canonical Terraform revision. Capture new evidence only from a **real deployment**, and keep sensitive raw records in an access-controlled location.

## Required per-test metadata

- UTC date/time, repository commit SHA and CI run URL
- AWS account alias (not raw credentials), region, Terraform version and provider versions
- Test name, precise command and parameters, expected result, actual result and exit code
- Sanitized output or screenshot; an explicit PASS/FAIL/NOT-RUN with reviewer notes
- Cost impact and cleanup status

## Suggested execution record

```text
Test: CloudTrail delivery and KMS decryption
Git SHA:
Timestamp (UTC):
AWS sandbox/region:
Command(s):
Expected:
Observed (redacted):
Exit code:
Result: NOT RUN
Reviewer:
Remediation:
```

Verify actual live IAM/SSM access, VPC route tables, CloudTrail status **and object delivery**, S3 encryption, Flow Logs, CloudWatch alarm/SNS receipt, AWS Budgets, and the EC2 web endpoint. Record rejected permission/KMS errors as failures, not success.

Never commit `tfplan`, `terraform.tfstate`, `.tfvars` with real values, secret ARN values, key material or raw CloudTrail logs.
