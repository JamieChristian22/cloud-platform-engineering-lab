# AWS VPC Terraform Lab

A cost-conscious, production-inspired networking case study for associate cloud/platform engineers. This is a **new, isolated Terraform root module**; existing landing-zone implementations are preserved for comparison and migration review.

## Architecture
- One VPC (default `10.20.0.0/16`) across two available Availability Zones
- Two public subnets (`10.20.1.0/24`, `10.20.2.0/24`)
- Two private subnets (`10.20.11.0/24`, `10.20.12.0/24`)
- Internet gateway and a public default route
- Explicit private route table **without** a default internet route
- No EC2, NAT gateway, Elastic IP, or public IP auto-assignment

Public subnet means a subnet with a route to an internet gateway, **not** that its resources automatically have public IPs. This is a networking foundation, not a complete production landing zone.

## Tools and learning goals
- **Git:** track changes and review pull requests.
- **Terraform:** declare infrastructure as code, format, validate, plan and (optionally) provision it.
- **AWS provider:** translates Terraform configuration into AWS API operations.
- **GitHub Actions:** automatically checks formatting and configuration validity.
- **AWS CLI (optional):** inspect cloud identity and deployed networking.

## Local validation (no AWS deployment)
From this folder:
```sh
terraform version
terraform init -backend=false -lockfile=readonly
terraform fmt -check -recursive
terraform validate
terraform test -no-color
```
`init -backend=false -lockfile=readonly` installs the provider pinned by `.terraform.lock.hcl` without configuring remote state or modifying the lock file. `validate` checks configuration structure; `terraform test` runs mocked, plan-only assertions from `tests/network.tftest.hcl` without AWS credentials. Provider download requires internet connectivity. These commands do not provision AWS resources.

## Optional cloud workflow (may incur AWS charges)
Only with an approved AWS sandbox and explicit cost review:
```sh
aws sts get-caller-identity
terraform plan -out=lab.tfplan
terraform show lab.tfplan
terraform apply lab.tfplan
terraform destroy
```
Never commit plan files, state, credentials or secrets. AWS credentials should be supplied through approved short-lived authentication, not hardcoded into Terraform. **Do not run apply by default.** AWS networking resources can have costs depending on region, account, and future extensions; a budget alert does not cap spending.

## Architecture and automated tests
See [the architecture and design decision guide](architecture/README.md) for the network diagram, resource map, decisions, and limitations.

`tests/network.tftest.hcl` uses a mocked AWS provider, with one simulated in-memory apply and plan-only runs to check subnet layout, zone distribution, IP assignment behavior, route-table associations, and configurable CIDRs. Test results in CI are static/model-based, **not live-cloud connectivity proof**. The checked-in `.terraform.lock.hcl` pins the provider version and release hashes for repeatable builds.

## Case studies
1. **Private subnet egress failure:** an application cannot download packages from the internet. Explain that private route tables have no default route; choose an approved NAT or VPC endpoint design after cost review rather than opening everything.
2. **Public subnet reachability:** a workload isn't reachable even with an IGW. Check public IP assignment, route tables, security groups, network ACLs, host firewall and application listener.
3. **Availability-zone resilience:** identify why spreading subnets across two AZs helps and why a single NAT gateway in one AZ can still be a failure dependency.
4. **Terraform drift:** explain how `terraform plan` compares desired configuration to tracked state and provider-observed infrastructure; don't blindly apply drift corrections.

## Acceptance criteria
- CI reports formatting and validation results.
- Reviewers can trace VPC/subnet/route table relationships.
- No default SSH ingress, NAT gateway or EC2 instance.
- No secrets or state files committed.
- Document any real deployment separately with redacted evidence and a cleanup checklist.

## Existing code review
The older `01-enterprise-landing-zone/terraform/main.tf` contains an SSH CIDR placeholder. The nested `01-enterprise-landing-zone/terraform/terraform/network.tf` provisions a NAT gateway and Elastic IP. Neither is modified by this lab; review their impact before applying those older roots.
