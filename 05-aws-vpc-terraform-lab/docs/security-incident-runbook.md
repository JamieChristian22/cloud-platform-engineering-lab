# Security group and routing incident response lab

**Scope:** Reasoning exercises for the Terraform configuration in `05-aws-vpc-terraform-lab/`. No AWS resources are deployed by this lab or by the CI workflow. These scenarios are hypothetical, not evidence of resolved real production incidents.

## Mental model: five independent checks

1. **Destination and listener:** Does a workload actually exist and listen on the expected port?
2. **DNS/IP addressing:** Does the client resolve and reach the correct IP address?
3. **Routing:** Is there a route to the destination network, including a return path?
4. **Security group:** Does the destination SG allow incoming traffic from the source SG or CIDR, and does the source SG allow outbound traffic?
5. **NACL/host firewall:** Do subnet network ACLs and the OS firewall permit the flow?

Security groups are stateful, but they are attached to network interfaces, **not** to subnets. The provided network module does not attach these groups to any running workloads.

## Incident 001 — HTTPS from outside the VPC times out

**Expected behavior:** Denied. `web_https_from_vpc` allows TCP 443 only when the source IP is inside `var.vpc_cidr`. The network has no instance, load balancer, public IPv4 assignment, or public listener.

**Triage:** In the repository, inspect `security.tf`, verify the ingress CIDR, then inspect the public subnet's routing and auto-public-IP setting. If a real deployment were ever authorized, check host/service listener, public IP and a deliberately reviewed ingress policy.

**Do not:** Solve this by adding `0.0.0.0/0` to the web ingress or SSH rule without a specific approved requirement.

## Incident 002 — Web tier cannot connect to app tier on TCP 8080

**Expected architecture:** Web SG outbound TCP 8080 references App SG; App SG inbound TCP 8080 references Web SG.

**Potential causes:** The workload is not associated with the intended SG, application not listening on 8080, incorrect destination IP/DNS, subnet ACL deny, workload-level firewall, or missing route.

**Simulated resolution:** Confirm both SG-to-SG rules using `terraform test` and `security.tf`. In a live environment, verify actual ENI security group attachments and reachability before changing rules.

## Incident 003 — Private subnet cannot download packages

**Expected behavior:** Private subnets have no default route to internet/NAT. This is intentional and costs nothing to provision while undeployed.

**Potential approved solutions:** VPC interface/gateway endpoints for supported services, a reviewed NAT gateway (incurs hourly/data costs), or provisioning through an approved internal artifact repository.

**Do not:** Change a private route to an internet gateway and assume the instance is safely reachable.

## Incident 004 — SSH port 22 refuses connections

**Expected behavior:** The lab intentionally defines no inbound SSH rules and no EC2 instances.

**Safer future design:** Use AWS Systems Manager Session Manager where supported, with IAM-scoped access and proper agent/network setup. Never insert unrestricted `0.0.0.0/0` SSH access.

## What the commands mean (no AWS resources created)

```sh
terraform fmt -check -recursive
terraform init -backend=false -lockfile=readonly
terraform validate
terraform test -no-color
```

- `fmt -check -recursive`: reads Terraform files to verify consistent formatting; does not rewrite them.
- `init -backend=false -lockfile=readonly`: prepares the pinned provider without remote state configuration; downloads dependencies, but does not call the AWS API to create resources.
- `validate`: static Terraform configuration validation; does not require AWS infrastructure.
- `test -no-color`: runs mocked Terraform plan/apply checks from the `tests` directory. Mocked applies happen only in the test context and do not deploy AWS resources.

## Review evidence

Capture a GitHub Actions URL and the exact commit SHA for a successful run. Distinguish this from live AWS deployment verification, which has **not** been performed. Never publish secrets, account identifiers, or sensitive session details.

## Guardrails and limitations

The standalone Terraform security group rules do not audit out-of-band rules added by humans in a live account. AWS may create a permissive default egress rule on SG creation; before any future real deployment, inspect effective AWS rules and ensure any default egress is removed. A simulated Terraform test can establish code intent, but not guarantee real-world enforcement or reachability. No deployment is authorized by this training document.
