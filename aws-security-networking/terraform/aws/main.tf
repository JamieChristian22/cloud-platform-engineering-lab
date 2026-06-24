provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-aws-vpc"
  })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.aws_public_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-aws-public-subnet"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.aws_private_subnet_cidr

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-aws-private-subnet"
    Tier = "private"
  })
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-aws-web-sg"
  description = "Allow HTTPS inbound and restricted outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound HTTPS only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_s3_bucket" "evidence" {
  bucket = "${var.project_name}-${var.environment}-evidence-${random_id.suffix.hex}"

  tags = local.common_tags
}

resource "random_id" "suffix" {
  byte_length = 4
}
