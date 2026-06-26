# Systems Manager Automation

## Purpose

AWS Systems Manager Automation allows platform engineers to automate operational tasks.

## Automation Document

`AWS-RestartEC2Instance`

## Use Case

Restarting an unhealthy EC2 instance after investigation or approval.

## Workflow

Operator or alarm identifies issue → Systems Manager Automation → EC2 restart → Validation through CloudWatch.

## Screenshot

Save pre-execution evidence as:

`08a-automation-document.png`
