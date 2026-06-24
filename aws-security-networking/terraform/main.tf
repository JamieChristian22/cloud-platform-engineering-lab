# Terraform example for portfolio validation.
# Replace variable values with your real cloud account details before deployment.

terraform {
  required_version = ">= 1.5.0"
}

locals {
  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

# This file documents the intended infrastructure pattern.
# Actual deployment should be completed cloud-by-cloud using the provider folders.
