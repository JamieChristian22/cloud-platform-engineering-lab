terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = "Terraform Enterprise Foundation"
    Environment = var.environment
    Owner       = "JamieChristian"
    ManagedBy   = "Terraform"
  }
}

module "networking" {
  source = "../../modules/networking"

  vpc_name                  = var.vpc_name
  environment               = var.environment
  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidr        = var.public_subnet_cidr
  private_subnet_cidr       = var.private_subnet_cidr
  public_availability_zone  = var.public_availability_zone
  private_availability_zone = var.private_availability_zone
  tags                      = local.common_tags
}

module "security" {
  source = "../../modules/security"

  security_group_name = var.security_group_name
  vpc_id              = module.networking.vpc_id
  ssh_allowed_cidrs   = var.ssh_allowed_cidrs
  tags                = local.common_tags
}

module "compute" {
  source = "../../modules/compute"

  instance_name     = var.instance_name
  environment       = var.environment
  instance_type     = var.instance_type
  public_subnet_id  = module.networking.public_subnet_id
  security_group_id = module.security.security_group_id
  tags              = local.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  sns_topic_name = var.sns_topic_name
  cpu_alarm_name = var.cpu_alarm_name
  cpu_threshold  = var.cpu_threshold
  instance_id    = module.compute.instance_id
  tags           = local.common_tags
}
