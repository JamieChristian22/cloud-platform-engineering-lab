variable "sns_topic_name" { type = string }
variable "cpu_alarm_name" { type = string }
variable "cpu_threshold" { type = number }
variable "instance_id" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
