# AWS Config Compliance Rules

## Rule Used

Recommended rule:

`restricted-ssh`

If unavailable, use:

`incoming-ssh-disabled`

or

`vpc-sg-open-only-to-authorized-ports`

## Purpose

The rule checks whether security groups allow risky SSH exposure.

## Compliance Value

Security groups that allow SSH from unrestricted sources can create security risk. AWS Config helps detect this condition.

## Screenshot

Save evidence as:

`07b-config-rule.png`
