variable "security_group_name" { type = string }
variable "vpc_id" { type = string }
variable "ssh_allowed_cidrs" { type = list(string) }

variable "http_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "https_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
