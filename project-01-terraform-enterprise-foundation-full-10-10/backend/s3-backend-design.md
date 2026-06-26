# S3 Backend Design

Production Terraform should store state remotely in S3 with encryption and versioning.

Recommended backend:
```hcl
terraform {
  backend "s3" {
    bucket         = "enterprise-terraform-state"
    key            = "terraform-enterprise-foundation/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```
