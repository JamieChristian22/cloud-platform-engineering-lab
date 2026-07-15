output "vpc_id" { value = aws_vpc.main.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
output "web_public_ip" { value = aws_instance.web.public_ip }
output "web_url" { value = "http://${aws_instance.web.public_dns}" }
output "audit_bucket_name" { value = aws_s3_bucket.audit.id }
output "sns_topic_arn" { value = aws_sns_topic.alerts.arn }
