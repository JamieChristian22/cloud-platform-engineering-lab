resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-web-sg"
  description = "HTTP demo workload; management via SSM, not public SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Public HTTP for demonstration only"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound access for package updates and SSM"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name_prefix}-web-sg" }
}

resource "aws_kms_key" "logs" {
  description             = "KMS key for landing zone logs"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "logs" {
  name          = "alias/${local.name_prefix}-logs"
  target_key_id = aws_kms_key.logs.key_id
}
