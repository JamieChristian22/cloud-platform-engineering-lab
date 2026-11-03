# Project acceptance checklist — canonical Terraform source

## Code review

- [x] Single authoritative Terraform root under `terraform/terraform/`
- [x] All operational scripts point to that root
- [x] No public SSH rule on the demo EC2 instance
- [x] KMS service access policies and audit-bucket protections encoded in Terraform
- [x] NAT gateway disabled by default to limit charges
- [x] Automated repository contracts and a CI validation workflow added
- [x] README, security, runbook and evidence disclosures updated

## Automated quality gates

Check the **latest PR commit**; only tick these after a successful run:
- [ ] Python and deployment safety tests pass
- [ ] Shell scripts parse with `bash -n` and ShellCheck
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform init -backend=false` and `terraform validate` pass
- [ ] Kubernetes dev and prod overlays render and pass policy checks
- [ ] No unexplained security-scanner findings

## Live AWS acceptance (intentionally not claimed)

- [ ] State backend, ownership and migration plan approved
- [ ] Terraform plan reviewed in a sandbox account; expected cost understood
- [ ] Infrastructure apply successful with recorded commit and UTC timestamp
- [ ] SSM Session Manager works, no SSH ingress exists
- [ ] HTTP demo reachable (or deployment limited to private access)
- [ ] CloudTrail writes and KMS-encrypted logs can be retrieved
- [ ] VPC Flow Logs are ingested and permissions work
- [ ] CPU alarm and encrypted SNS delivery independently verified
- [ ] Budget alert recipient confirmed and observed costs reviewed
- [ ] Teardown completed with intentional audit-retention decision
