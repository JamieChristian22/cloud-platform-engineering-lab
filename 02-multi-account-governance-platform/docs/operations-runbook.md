# Operations Runbook

## Review Organization
Open AWS Organizations and confirm the Organization ID and management account.

## Review OUs
Confirm Infrastructure, Security, Workloads, and Sandbox.

## Review SCPs
Confirm SCPs are enabled and deny-leave-organization is attached to Sandbox.

## Change Control
1. Draft policy.
2. Test in Sandbox.
3. Document impact.
4. Attach to target OU.
5. Capture evidence.

## Rollback
Detach the policy from the affected OU and document rollback.
