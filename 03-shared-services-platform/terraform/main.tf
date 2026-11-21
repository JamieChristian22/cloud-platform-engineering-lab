resource "aws_vpc" "shared_services" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "shared-services-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.shared_services.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "shared-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.shared_services.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "shared-private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.shared_services.id

  tags = {
    Name = "shared-services-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.shared_services.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "shared-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# A private subnet should have an explicit route table with no default
# internet/NAT route. The VPC-local route is managed by AWS.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.shared_services.id

  tags = {
    Name = "shared-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Adopt the default SG created with this new VPC. Terraform removes
# its default inbound and outbound rules; do not reuse blindly on a
# VPC already serving workloads.
resource "aws_default_security_group" "locked_down" {
  vpc_id = aws_vpc.shared_services.id

  tags = {
    Name = "shared-services-default-deny"
  }
}

resource "aws_cloudwatch_log_group" "application" {
  name              = "/shared/services/application"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "security" {
  name              = "/shared/services/security"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "platform" {
  name              = "/shared/services/platform"
  retention_in_days = 30
}
