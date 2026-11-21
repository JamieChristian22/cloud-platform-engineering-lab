variable "aws_region" {
  description = "AWS region for the network."
  type        = string
  default     = "us-east-1"
}
variable "project_name" {
  description = "Prefix for AWS resource names."
  type        = string
  default     = "platform-vpc-lab"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.project_name))
    error_message = "Use 3-31 lowercase letters, digits, and hyphens; start with a letter."
  }
}
variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "lab"
  validation {
    condition     = contains(["lab", "dev", "test", "prod"], var.environment)
    error_message = "Choose lab, dev, test, or prod."
  }
}
variable "vpc_cidr" {
  description = "Private RFC1918 VPC CIDR. This lab expects a /16."
  type        = string
  default     = "10.20.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) && can(regex("^10\\.[0-9]+\\.0\\.0/16$", var.vpc_cidr))
    error_message = "Use a 10.x.0.0/16 CIDR for this lab."
  }
}
