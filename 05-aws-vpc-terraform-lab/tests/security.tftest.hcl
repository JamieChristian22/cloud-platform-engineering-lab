# Runs only with a mocked AWS provider. No credentials or live AWS resources.
mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = ["us-east-1a", "us-east-1b"]
    }
  }
}

run "security_group_least_privilege" {
  # Apply is in-memory simulation because resource-generated IDs are used.
  command = apply

  assert {
    condition     = aws_security_group.web.vpc_id == aws_vpc.lab.id && aws_security_group.app.vpc_id == aws_vpc.lab.id
    error_message = "Web and app security groups must belong to the lab VPC."
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.web_https_from_vpc.ip_protocol == "tcp" && aws_vpc_security_group_ingress_rule.web_https_from_vpc.from_port == 443 && aws_vpc_security_group_ingress_rule.web_https_from_vpc.to_port == 443
    error_message = "Web ingress must be restricted to HTTPS/TCP 443."
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.web_https_from_vpc.cidr_ipv4 == var.vpc_cidr
    error_message = "Web HTTPS ingress must be limited to the VPC, not the public internet."
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.app_from_web.referenced_security_group_id == aws_security_group.web.id
    error_message = "Application ingress must reference the web security group."
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.app_from_web.from_port == 8080 && aws_vpc_security_group_ingress_rule.app_from_web.to_port == 8080 && aws_vpc_security_group_ingress_rule.app_from_web.ip_protocol == "tcp"
    error_message = "Application ingress must be TCP 8080 only."
  }

  assert {
    condition     = aws_vpc_security_group_egress_rule.web_to_app.referenced_security_group_id == aws_security_group.app.id
    error_message = "Web outbound application traffic must reference the app security group."
  }

  assert {
    condition     = aws_vpc_security_group_egress_rule.web_to_app.from_port == 8080 && aws_vpc_security_group_egress_rule.web_to_app.to_port == 8080 && aws_vpc_security_group_egress_rule.web_to_app.ip_protocol == "tcp"
    error_message = "Web-to-app outbound rule must only allow TCP 8080."
  }
}

run "custom_cidr_updates_web_allowlist" {
  command = plan

  variables {
    vpc_cidr = "10.42.0.0/16"
  }

  assert {
    condition     = aws_vpc_security_group_ingress_rule.web_https_from_vpc.cidr_ipv4 == "10.42.0.0/16"
    error_message = "Custom network CIDRs must update the web HTTPS source rule."
  }
}
