# Lucidchart AI Prompt — Terraform Enterprise Foundation

Create a professional AWS architecture diagram titled "Terraform Enterprise Foundation".

Use official AWS icons. Show a developer workstation using Terraform CLI and AWS CLI deploying reusable Terraform modules into AWS.

Include:
- modules/networking
- modules/security
- modules/compute
- modules/monitoring
- environments/dev, test, prod

AWS resources:
- VPC: dev-enterprise-vpc, CIDR 10.20.0.0/16
- Public subnet: 10.20.1.0/24
- Private subnet: 10.20.2.0/24
- Internet Gateway
- Public route table: 0.0.0.0/0 to Internet Gateway
- Security Group: dev-web-sg
- EC2 instance: dev-web-server
- IAM role: dev-web-server-ssm-role
- CloudWatch alarm: dev-high-cpu-alarm
- SNS topic: dev-ops-alerts

Show flow:
Developer -> Terraform -> AWS Provider -> Modules -> AWS Resources
EC2 -> CloudWatch Alarm -> SNS Topic
Internet -> Internet Gateway -> Public Subnet -> EC2

White background, clean enterprise layout, professional portfolio quality.
