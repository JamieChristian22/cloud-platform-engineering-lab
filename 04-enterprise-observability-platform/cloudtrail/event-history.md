# CloudTrail Event History

## EC2 Event Filter

Lookup attribute:

`Event source`

Value:

`ec2.amazonaws.com`

Use case:
Investigate EC2 actions such as instance starts, stops, launches, and configuration changes.

## IAM Event Filter

Lookup attribute:

`Event source`

Value:

`iam.amazonaws.com`

Use case:
Investigate IAM changes, role updates, policy attachments, and access control activity.

## Overview Filter

Use no filter to show general account activity across AWS services.

## Operational Use

CloudTrail Event History is often the first place to check during unexpected infrastructure changes or security investigations.
