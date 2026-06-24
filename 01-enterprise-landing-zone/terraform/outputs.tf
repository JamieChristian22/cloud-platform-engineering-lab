output "vpc_id" {
  description = "Enterprise VPC ID"
  value       = aws_vpc.enterprise_vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private_subnet.id
}

output "security_group_id" {
  description = "Web security group ID"
  value       = aws_security_group.web_sg.id
}
