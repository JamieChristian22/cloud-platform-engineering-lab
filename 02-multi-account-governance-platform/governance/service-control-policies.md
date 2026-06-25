# Service Control Policies

SCPs define maximum permissions available to AWS accounts. SCPs do not grant permissions.

## Policy Created
Name: deny-leave-organization

Purpose: Prevents accounts from leaving the AWS Organization.

## Policy JSON
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLeaveOrganization",
      "Effect": "Deny",
      "Action": ["organizations:LeaveOrganization"],
      "Resource": "*"
    }
  ]
}
```

## Attached Target
Sandbox OU
