variable "vpc_name" { type = string }
variable "environment" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidr" { type = string }
variable "private_subnet_cidr" { type = string }
variable "public_availability_zone" { type = string }
variable "private_availability_zone" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
