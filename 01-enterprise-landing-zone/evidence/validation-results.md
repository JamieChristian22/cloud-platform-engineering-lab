# Validation status — source code versus live deployment

**Do not infer that the AWS infrastructure is currently deployed from repository content.** CI output is associated with a commit and can become stale after edits.

| Check | Evidence source | Status recorded here |
| --- | --- | --- |
| Repository regression tests | GitHub Actions `AWS landing zone static validation` | Must be checked on final PR head |
| Shell script syntax | Same CI workflow | Must be checked on final PR head |
| Terraform formatting | Same CI workflow | Must be checked on final PR head |
| Terraform init/validate (provider schema, no AWS apply) | Same CI workflow | Must be checked on final PR head |
| Kubernetes dev/prod Kustomize rendering | CI and local `kubectl kustomize` | Must be checked on final PR head |
| AWS plan approved against target account/state | Privately retained sanitized output | **Not verified** |
| EC2/SSM/web service | Timestamped live test | **Not verified** |
| CloudTrail, KMS and S3 log delivery | Timestamped AWS CLI commands and delivered objects | **Not verified** |
| VPC Flow Logs and alarm/SNS notification delivery | Timestamped AWS test | **Not verified** |
| Actual AWS spend and controlled teardown | Billing report and residual-resource review | **Not verified** |

The existing screenshot and legacy manual-setup notes may document a prior environment; they do **not** prove the canonical Terraform version is running.

Never commit account credentials, plan/state files, private IP addresses where sensitive, signed URLs or unredacted CloudTrail payloads. See [evidence instructions](deployment-evidence.md).
