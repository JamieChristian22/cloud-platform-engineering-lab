# Security review / open findings

**Review status:** static source inspection. Not a live security assessment or penetration test.

## Risk register

| Finding | Current mitigation | Residual concern / action |
| --- | --- | --- |
| Public HTTP demo endpoint | Dedicated sandbox workload; security group allows HTTP only (no inbound SSH) | Replace with TLS/ALB/private instance for production |
| Single-account scope | Explicitly labeled a lab | Introduce org guardrails, multi-account boundaries, central identity for enterprise adoption |
| Single NAT option | Opt-in, disabled by default | No private internet without NAT; enable per-AZ NAT/endpoints only when justified |
| Broad EC2 egress | Required to simplify demo bootstrapping | Reduce to endpoints/allowlisted destinations for production |
| KMS / service delivery failure | Key policies for CloudTrail, CloudWatch Logs and CloudWatch→SNS defined | Verify actual KMS permissions and delivery with AWS tests |
| S3 log retention | Encryption, TLS-only, versioning and no force destroy | Confirm retention standards, noncurrent version management and cleanup costs |
| Unverified live controls | CI validates source | Collect dated SSM/log/notification/teardown evidence |

The original manual SSH and broad IAM-group guidance is historical and not part of the canonical Terraform source. No AWS Config/GuardDuty organization deployment or security-hub posture evaluation is asserted here.
