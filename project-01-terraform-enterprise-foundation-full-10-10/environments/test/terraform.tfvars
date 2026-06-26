aws_region  = "us-east-1"
environment = "test"

vpc_name = "test-enterprise-vpc"
vpc_cidr = "10.30.0.0/16"

public_subnet_cidr  = "10.30.1.0/24"
private_subnet_cidr = "10.30.2.0/24"

public_availability_zone  = "us-east-1a"
private_availability_zone = "us-east-1b"

security_group_name = "test-web-sg"

# Replace with your public IP /32 for stronger security.
ssh_allowed_cidrs = ["0.0.0.0/0"]

instance_name = "test-web-server"
instance_type = "t2.micro"

sns_topic_name = "test-ops-alerts"
cpu_alarm_name = "test-high-cpu-alarm"
cpu_threshold  = 70
