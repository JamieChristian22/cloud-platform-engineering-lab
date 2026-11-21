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

variable "enable_flow_logs" {
  description = "Opt in to AWS VPC Flow Logs, CloudWatch Logs, and an alarm. Defaults to false to avoid accidental costs."
  type        = bool
  default     = false
}

variable "flow_log_retention_days" {
  description = "CloudWatch Logs retention when flow logging is explicitly enabled."
  type        = number
  default     = 7
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90], var.flow_log_retention_days)
    error_message = "Choose one of the supported lab retention periods: 1, 3, 5, 7, 14, 30, 60, or 90 days."
  }
}

variable "availability_zone_ids" {
  description = "Exactly two region-specific Availability Zone IDs; defaults apply to us-east-1."
  type        = list(string)
  default     = ["use1-az1", "use1-az2"]

  validation {
    condition     = length(var.availability_zone_ids) == 2 && length(distinct(var.availability_zone_ids)) == 2
    error_message = "Provide exactly two distinct Availability Zone IDs valid in the chosen AWS region."
  }
}
