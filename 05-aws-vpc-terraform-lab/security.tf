# Define reusable security-group policies for future workloads.
# No EC2 instances, ENIs, load balancers, or Kubernetes resources are created here.
# Security groups are attached to workload network interfaces, not to subnets.

resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-web-"
  description = "Internal HTTPS entrypoint; workload attachment is a separate project"
  vpc_id      = aws_vpc.lab.id

  tags = {
    Name = "${var.project_name}-web-sg"
    Tier = "web"
  }
}

resource "aws_security_group" "app" {
  name_prefix = "${var.project_name}-app-"
  description = "Private application tier; allow TCP 8080 from web tier only"
  vpc_id      = aws_vpc.lab.id

  tags = {
    Name = "${var.project_name}-app-sg"
    Tier = "app"
  }
}

# Only VPC-internal clients may initiate HTTPS to future web-tier workloads.
# This rule is NOT an internet-facing 0.0.0.0/0 HTTPS allowance.
resource "aws_vpc_security_group_ingress_rule" "web_https_from_vpc" {
  security_group_id = aws_security_group.web.id
  description       = "Allow HTTPS only from addresses within the VPC"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = var.vpc_cidr
}

# Allow application requests only when the source uses the web security group.
resource "aws_vpc_security_group_ingress_rule" "app_from_web" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.web.id
  description                  = "Web tier to application tier on TCP 8080"
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

# Restrict explicitly managed outbound web-tier traffic to the app tier.
# No internet-wide outbound rule is defined.
resource "aws_vpc_security_group_egress_rule" "web_to_app" {
  security_group_id            = aws_security_group.web.id
  referenced_security_group_id = aws_security_group.app.id
  description                  = "Web tier to private app tier on TCP 8080"
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

# Adopt the VPC's automatically-created default SG and remove its default
# inbound/outbound rules. The VPC in this lab is newly created; do not copy
# this resource blindly into an existing production VPC without assessing users.
resource "aws_default_security_group" "locked_down" {
  vpc_id = aws_vpc.lab.id

  tags = { Name = "${var.project_name}-default-deny" }
}
