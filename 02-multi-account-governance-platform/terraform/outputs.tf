output "infrastructure_ou_id" {
  value = aws_organizations_organizational_unit.infrastructure.id
}

output "security_ou_id" {
  value = aws_organizations_organizational_unit.security.id
}

output "workloads_ou_id" {
  value = aws_organizations_organizational_unit.workloads.id
}

output "sandbox_ou_id" {
  value = aws_organizations_organizational_unit.sandbox.id
}
