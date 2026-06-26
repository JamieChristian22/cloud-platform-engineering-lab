# Project 01 — Terraform Enterprise Foundation

## Overview
This project demonstrates an enterprise-style Terraform foundation for AWS infrastructure using reusable modules, environment separation, variables, outputs, scripts, documentation, and evidence tracking.

## Business Problem
Cloud teams need repeatable infrastructure deployment across environments. Manual console builds cause inconsistent networking, security drift, missing monitoring, weak documentation, and unreliable rebuilds.

## Solution
This project provisions an AWS foundation with Terraform modules.

## What This Deploys
- VPC
- Public subnet
- Private subnet
- Internet Gateway
- Public route table
- Security group
- EC2 web server
- IAM role for Systems Manager
- SNS topic
- CloudWatch high CPU alarm

## Structure
```text
project-01-terraform-enterprise-foundation
├── architecture
├── backend
├── docs
├── evidence
├── scripts
├── modules
│   ├── networking
│   ├── security
│   ├── compute
│   └── monitoring
└── environments
    ├── dev
    ├── test
    └── prod
```

## Deploy Dev
```bash
cd environments/dev
terraform init
terraform validate
terraform plan
terraform apply
```

## Destroy
```bash
terraform destroy
```

## Evidence Screenshots
- 01-terraform-version.png
- 02-aws-cli-version.png
- 03-aws-identity.png
- 04-project-folder-structure.png
- 05-networking-module.png
- 06-terraform-init-validate.png
- 07-terraform-plan.png
- 08-terraform-apply.png
- 09-aws-resources-created.png
- 10-terraform-destroy.png

## Skills Demonstrated
Terraform, AWS, IaC, reusable modules, networking, IAM, EC2, CloudWatch, SNS, Dev/Test/Prod structure, documentation, and cleanup workflow.
