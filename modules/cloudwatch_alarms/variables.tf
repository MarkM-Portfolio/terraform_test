
variable "cloudwatch_alarm_configs_in" {
  description = "Cloudwatch configurations for ASGs Unhealthy Hosts alarms."
  type        = map(any)
}

variable "billing_alarm_configs_in" {
  description = "Billing alarm configurations"
  type        = map(any)
}

variable "us_east_1" {
  type    = string
  default = "us-east-1"
}