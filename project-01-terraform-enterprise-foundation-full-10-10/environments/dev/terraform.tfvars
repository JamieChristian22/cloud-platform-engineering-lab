aws_region  = "us-east-1"
environment = "dev"

vpc_name = "dev-enterprise-vpc"
vpc_cidr = "10.20.0.0/16"

public_subnet_cidr  = "10.20.1.0/24"
private_subnet_cidr = "10.20.2.0/24"

public_availability_zone  = "us-east-1a"
private_availability_zone = "us-east-1b"

security_group_name = "dev-web-sg"

# Replace with your public IP /32 for stronger security.
ssh_allowed_cidrs = ["0.0.0.0/0"]

instance_name = "dev-web-server"
instance_type = "t2.micro"

sns_topic_name = "dev-ops-alerts"
cpu_alarm_name = "dev-high-cpu-alarm"
cpu_threshold  = 70
