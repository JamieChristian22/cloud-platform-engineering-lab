variable "aws_region" {
  description = "AWS region used for the landing zone workload."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used in resource naming."
  type        = string
  default     = "enterprise-landing-zone"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "portfolio"

  validation {
    condition     = contains(["dev", "test", "stage", "prod", "portfolio"], var.environment)
    error_message = "environment must be dev, test, stage, prod, or portfolio."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_ssh_cidr" {
  description = "Trusted administrator CIDR for SSH. Use your public IP with /32."
  type        = string

  validation {
    condition     = var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "SSH access must not be open to the internet."
  }
}

variable "notification_email" {
  description = "Email address subscribed to operational and budget alerts."
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly budget limit in USD."
  type        = number
  default     = 25
}

variable "instance_type" {
  description = "EC2 instance type for the demonstration workload."
  type        = string
  default     = "t3.micro"
}
