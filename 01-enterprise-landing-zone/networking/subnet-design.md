# Subnet Design

## Public Subnet

Name: `enterprise-public-subnet`

CIDR: `10.0.1.0/24`

Purpose:
- Hosts internet-facing resources
- Contains EC2 web server

## Private Subnet

Name: `enterprise-private-subnet`

CIDR: `10.0.2.0/24`

Purpose:
- Reserved for internal resources
- Future database or application tier placement

## Design Value

Public/private subnet separation demonstrates enterprise network segmentation.
