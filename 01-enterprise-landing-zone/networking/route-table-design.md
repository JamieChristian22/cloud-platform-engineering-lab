# Route Table Design

## Public Route Table

Name: `enterprise-public-rt`

Routes:
- `10.0.0.0/16` -> local
- `0.0.0.0/0` -> Internet Gateway

Subnet association:
- `enterprise-public-subnet`

## Purpose

The public route table allows the EC2 web server to receive internet traffic.
