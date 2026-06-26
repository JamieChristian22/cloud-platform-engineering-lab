output "instance_id" { value = aws_instance.web.id }
output "public_ip" { value = aws_instance.web.public_ip }
output "public_dns" { value = aws_instance.web.public_dns }
output "iam_role_name" { value = aws_iam_role.ec2_ssm_role.name }
