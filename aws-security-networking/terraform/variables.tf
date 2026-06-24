variable "project_name" {
  description = "Name of the portfolio project"
  type        = string
  default     = "multi-cloud-portfolio-project"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Resource owner"
  type        = string
  default     = "Jamie Christian II"
}

variable "location" {
  description = "Primary cloud region"
  type        = string
  default     = "us-east-1"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_vpc_cidr" {
  description = "AWS VPC CIDR"
  type        = string
  default     = "10.10.0.0/16"
}

variable "aws_public_subnet_cidr" {
  description = "AWS public subnet CIDR"
  type        = string
  default     = "10.10.1.0/24"
}

variable "aws_private_subnet_cidr" {
  description = "AWS private subnet CIDR"
  type        = string
  default     = "10.10.2.0/24"
}

variable "azure_location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "azure_vnet_cidr" {
  description = "Azure VNet CIDR"
  type        = string
  default     = "10.20.0.0/16"
}

variable "azure_private_subnet_cidr" {
  description = "Azure private subnet CIDR"
  type        = string
  default     = "10.20.1.0/24"
}

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = "replace-with-your-gcp-project-id"
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_private_subnet_cidr" {
  description = "GCP private subnet CIDR"
  type        = string
  default     = "10.30.1.0/24"
}
