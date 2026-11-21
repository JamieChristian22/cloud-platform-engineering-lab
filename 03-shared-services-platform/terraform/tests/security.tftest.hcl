# All assertions use a mocked AWS provider. No credentials or AWS calls.
mock_provider "aws" {}

run "shared_services_network_baseline" {
  # Simulated apply is in memory and cannot deploy resources in AWS.
  command = apply

  assert {
    condition     = aws_subnet.public.map_public_ip_on_launch == false
    error_message = "The public subnet must never automatically issue public IPv4 addresses."
  }

  assert {
    condition     = aws_route_table_association.public.subnet_id == aws_subnet.public.id
    error_message = "The public subnet must retain its explicit public route-table association."
  }

  assert {
    condition     = aws_route_table_association.private.subnet_id == aws_subnet.private.id && aws_route_table_association.private.route_table_id == aws_route_table.private.id
    error_message = "The private subnet must be associated with its dedicated private route table."
  }

  assert {
    condition     = length(aws_route_table.private.route) == 0
    error_message = "Do not add an internet or NAT default route to the private subnet."
  }

  assert {
    condition     = aws_default_security_group.locked_down.vpc_id == aws_vpc.shared_services.id
    error_message = "The new VPC must manage its default security group explicitly."
  }
}
