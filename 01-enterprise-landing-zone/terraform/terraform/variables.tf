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
variable "notification_email" {
  description = "Email address subscribed to operational and budget alerts."
  type        = string
  validation {
    condition     = can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", var.notification_email))
    error_message = "Provide a valid notification email address."
  }
}
variable "monthly_budget_usd" {
  description = "Monthly budget limit in USD."
  type        = number
  default     = 25
  validation {
    condition     = var.monthly_budget_usd > 0
    error_message = "monthly_budget_usd must be positive."
  }
}
variable "enable_nat_gateway" {
  description = "Opt in to a billable single-AZ NAT gateway for private subnet egress. Disabled by default for a low-cost lab."
  type        = bool
  default     = false
}
variable "instance_type" {
  description = "EC2 instance type for the demonstration workload."
  type        = string
  default     = "t3.micro"
}
