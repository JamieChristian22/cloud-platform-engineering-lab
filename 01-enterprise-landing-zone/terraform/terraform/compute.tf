resource "aws_iam_role" "ec2" {
  name = "${local.name_prefix}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${local.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = true
  monitoring                  = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 12
  }

  user_data = <<-USERDATA
    #!/bin/bash
    set -euxo pipefail
    dnf update -y
    dnf install -y httpd
    systemctl enable --now httpd
    cat > /var/www/html/index.html <<HTML
    <!doctype html><html><head><title>Enterprise Landing Zone</title></head>
    <body><h1>AWS Enterprise Landing Zone</h1><p>Securely provisioned with Terraform and GitHub Actions.</p></body></html>
    HTML
  USERDATA

  tags = { Name = "${local.name_prefix}-web" }
}
