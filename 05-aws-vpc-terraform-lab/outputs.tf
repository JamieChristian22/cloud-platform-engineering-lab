output "vpc_id" {
  description = "Created VPC identifier."
  value       = aws_vpc.lab.id
}
output "public_subnet_ids" {
  description = "Public subnet identifiers."
  value       = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  description = "Private subnet identifiers."
  value       = aws_subnet.private[*].id
}
output "public_subnet_cidrs" {
  value = local.public_cidrs
}
output "private_subnet_cidrs" {
  value = local.private_cidrs
}

output "web_security_group_id" {
  description = "Security group ID for future internal web-tier workloads."
  value       = aws_security_group.web.id
}

output "app_security_group_id" {
  description = "Security group ID for future private app-tier workloads."
  value       = aws_security_group.app.id
}
