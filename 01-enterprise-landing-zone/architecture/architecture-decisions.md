# Architecture Decisions

## Decision 1: Single VPC Foundation

The landing zone uses one VPC with CIDR `10.0.0.0/16`.

### Reason
A single VPC is simple enough for a portfolio project while still demonstrating enterprise network design fundamentals.

## Decision 2: Public and Private Subnet Segmentation

The environment separates workloads into:
- Public subnet: internet-facing resources
- Private subnet: internal resources

### Reason
This shows network segmentation and prepares the design for future application tiers.

## Decision 3: EC2 Web Server in Public Subnet

The EC2 instance is placed in the public subnet for direct browser validation.

### Reason
This provides visible proof that the network, route table, security group, and web server are working.

## Decision 4: SSH Restricted to My IP

SSH access is restricted to the administrator's current IP.

### Reason
This reduces exposure and follows basic security best practices.

## Decision 5: Multi-Region CloudTrail

CloudTrail is configured as a multi-region trail.

### Reason
This improves audit coverage across AWS regions.

## Decision 6: CloudWatch + SNS Alerting

CloudWatch alarm sends notifications to SNS.

### Reason
This demonstrates operational monitoring and alerting workflow.

## Decision 7: AWS Budget

AWS Budget is included for cost governance.

### Reason
Enterprise cloud environments require financial controls and alerting.
