variable "aws_region" {
  description = "AWS region for the landing zone"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project naming prefix"
  type        = string
  default     = "enterprise"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR range"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR range"
  type        = string
  default     = "10.0.2.0/24"
}
