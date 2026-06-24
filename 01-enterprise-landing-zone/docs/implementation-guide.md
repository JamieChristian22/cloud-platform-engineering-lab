# Implementation Guide

## 1. Cost Governance

Create AWS Budget:
- Name: `enterprise-budget`
- Budget type: Monthly cost budget
- Amount: `$5`
- Alerts: 50%, 80%, 100%
- Notification: email

## 2. VPC

Create VPC:
- Name: `enterprise-vpc`
- CIDR: `10.0.0.0/16`

## 3. Public Subnet

Create public subnet:
- Name: `enterprise-public-subnet`
- CIDR: `10.0.1.0/24`
- AZ: `us-east-1a`
- Auto-assign public IPv4: enabled

## 4. Private Subnet

Create private subnet:
- Name: `enterprise-private-subnet`
- CIDR: `10.0.2.0/24`
- AZ: `us-east-1b`
- Auto-assign public IPv4: disabled

## 5. Internet Gateway

Create and attach:
- Name: `enterprise-igw`
- Attached to: `enterprise-vpc`

## 6. Route Table

Create public route table:
- Name: `enterprise-public-rt`
- Route: `0.0.0.0/0` to Internet Gateway
- Associated subnet: `enterprise-public-subnet`

## 7. Security Group

Create security group:
- Name: `enterprise-web-sg`
- VPC: `enterprise-vpc`

Inbound:
- HTTP 80 from anywhere
- HTTPS 443 from anywhere
- SSH 22 from My IP

Outbound:
- All traffic

## 8. IAM Governance

Create groups:
- `enterprise-admins` with AdministratorAccess
- `enterprise-engineers` with PowerUserAccess
- `enterprise-auditors` with ReadOnlyAccess

## 9. EC2 Deployment

Launch instance:
- Name: `enterprise-web-server`
- AMI: Amazon Linux 2023
- Type: t2.micro or t3.micro
- Subnet: `enterprise-public-subnet`
- Public IP: enabled
- Security group: `enterprise-web-sg`
- Key pair: `enterprise-keypair`

## 10. SSH Connection

From Mac Terminal:

```bash
cd ~/Downloads
chmod 400 enterprise-keypair.pem
ssh -i enterprise-keypair.pem ec2-user@PUBLIC-IP
```

## 11. Apache Installation

Inside EC2:

```bash
sudo dnf update -y
sudo dnf install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Enterprise Landing Zone</h1><p>Cloud Platform Engineering Project</p>" | sudo tee /var/www/html/index.html
curl localhost
```

## 12. Website Validation

Open:

```text
http://PUBLIC-IP
```

Expected page:
- Enterprise Landing Zone
- Cloud Platform Engineering Project

## 13. CloudTrail

Create trail:
- Name: `enterprise-trail`
- Multi-region: enabled
- Management events: read/write
- Data events: disabled
- Insights: disabled
- Storage: S3 bucket

## 14. SNS

Create topic:
- Name: `enterprise-alerts`
- Type: Standard

Create subscription:
- Protocol: Email
- Endpoint: administrator email
- Confirm subscription from email inbox

## 15. CloudWatch Alarm

Create alarm:
- Metric: EC2 CPUUtilization
- Statistic: Average
- Period: 5 minutes
- Threshold: greater than 70
- Notification: SNS topic `enterprise-alerts`
- Name: `enterprise-high-cpu-alarm`

## 16. Architecture Diagram

Create a diagram that includes:
- Internet users
- Internet Gateway
- VPC
- Public subnet
- Private subnet
- EC2 web server
- Security group
- Route table
- IAM groups
- CloudTrail
- S3 log bucket
- CloudWatch alarm
- SNS topic
- AWS Budget
