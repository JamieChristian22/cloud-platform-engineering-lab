# Enterprise Observability Terraform — SNS Encryption

This is the standalone `04-enterprise-observability-platform/terraform/` source module, not proof of deployed AWS monitoring.

- `aws_sns_topic.ops_alerts.kms_master_key_id = "alias/aws/sns"` requests **SNS server-side encryption using the AWS-managed KMS key**.
- The key is **not customer-managed** and doesn't replace an approved KMS key policy for workloads that need specific AWS service principals or cross-account publication. Before connecting CloudWatch alarms, EventBridge rules or external publishers, verify publishing permissions and encryption compatibility for that design.
- The module contains a sample dashboard and SNS topic only. It does not create operational alarms, SNS email subscriptions, or live incidents. The broader project documents other exercises separately.
- Encryption can have AWS KMS-related request costs once deployed and used. No resources are deployed by CI.

The new `tests/encryption.tftest.hcl` exercises the intended topic policy with a mocked AWS provider. Legacy Checkov audit now hard-gates `CKV_AWS_26` on this exact SNS resource, and still reports other findings without automatically masking them.

```sh
terraform init -backend=false -input=false
terraform fmt -check -diff
terraform validate
terraform test -no-color
```

These checks are offline/provider-registry operations, **not** live AWS publishing or key-policy tests.
