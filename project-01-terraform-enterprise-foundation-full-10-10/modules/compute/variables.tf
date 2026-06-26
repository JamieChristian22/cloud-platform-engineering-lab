variable "instance_name" { type = string }
variable "environment" { type = string }
variable "instance_type" { type = string }
variable "public_subnet_id" { type = string }
variable "security_group_id" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
