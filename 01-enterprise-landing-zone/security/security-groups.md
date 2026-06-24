# Security Groups

## Security Group

`enterprise-web-sg`

## Inbound Rules

| Protocol | Port | Source | Purpose |
|---|---:|---|---|
| HTTP | 80 | Anywhere IPv4 | Web access |
| HTTPS | 443 | Anywhere IPv4 | Future secure web access |
| SSH | 22 | My IP | Administrator access |

## Outbound Rules

All outbound traffic is allowed.

## Security Value

The security group limits administrative access while allowing web traffic.
