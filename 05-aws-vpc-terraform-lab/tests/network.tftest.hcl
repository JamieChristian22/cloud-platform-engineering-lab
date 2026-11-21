# Mocked provider means these tests never contact AWS or create resources.
mock_provider "aws" {
  override_during = plan

  mock_data "aws_availability_zones" {
    defaults = {
      names = ["us-east-1a", "us-east-1b", "us-east-1c"]
    }
  }
}

run "two_az_network_layout" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2 && length(aws_subnet.private) == 2
    error_message = "The VPC must contain two public and two private subnets."
  }

  assert {
    condition     = output.public_subnet_cidrs == ["10.20.1.0/24", "10.20.2.0/24"]
    error_message = "Public subnet CIDRs do not match the planned network layout."
  }

  assert {
    condition     = output.private_subnet_cidrs == ["10.20.11.0/24", "10.20.12.0/24"]
    error_message = "Private subnet CIDRs do not match the planned network layout."
  }

  assert {
    condition     = aws_subnet.public[0].availability_zone != aws_subnet.public[1].availability_zone
    error_message = "Public subnets must be distributed across availability zones."
  }

  assert {
    condition     = aws_subnet.private[0].availability_zone != aws_subnet.private[1].availability_zone
    error_message = "Private subnets must be distributed across availability zones."
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.public : subnet.map_public_ip_on_launch == false])
    error_message = "Automatic public IP assignment must remain disabled."
  }

  assert {
    condition     = length(aws_route_table_association.public) == 2 && length(aws_route_table_association.private) == 2
    error_message = "Each subnet must be associated with its intended route table."
  }
}

run "custom_private_network_cidr" {
  command = plan

  variables {
    vpc_cidr     = "10.42.0.0/16"
    project_name = "custom-network-lab"
  }

  assert {
    condition     = aws_vpc.lab.cidr_block == "10.42.0.0/16"
    error_message = "The VPC must respect the requested CIDR."
  }

  assert {
    condition     = output.public_subnet_cidrs == ["10.42.1.0/24", "10.42.2.0/24"]
    error_message = "Custom CIDR must propagate to public subnets."
  }

  assert {
    condition     = output.private_subnet_cidrs == ["10.42.11.0/24", "10.42.12.0/24"]
    error_message = "Custom CIDR must propagate to private subnets."
  }
}
