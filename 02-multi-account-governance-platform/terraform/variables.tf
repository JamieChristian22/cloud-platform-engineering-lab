variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "root_id" {
  description = "AWS Organizations root ID"
  type        = string
}
