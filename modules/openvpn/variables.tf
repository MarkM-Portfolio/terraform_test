variable "name" {
  default = "openvpn"
  type    = string
}

variable "environment" {
  type        = string
  description = "E.g Dev, Staging or Prod"
}

variable "team" {
  type        = string
  description = "team e.g. kdp"
}

variable "image_id" {
  type        = string
  description = "Image Id to be used. you can generate the ami using packer. go to 'packer' directory under the root folder"
}

variable "user_data" {
  type        = string
  description = "User data script"
  default     = ""
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "vpc_id" {
  type        = string
  description = "vpc id where openvpn will be attached"
}

variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region to deploy the resource"
}

variable "strategy" {
  default     = "spread"
  type        = string
  description = "The placement strategy. Can be 'cluster', 'partition' or 'spread'. "
}

variable "max_size" {
  description = "max_size must be set to 1. there must be only 1 openvpn server running at a time"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "min_size must be set to 1. there must be only 1 openvpn server running at a time"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "desired_capacity must be set to 1. there must be only 1 openvpn server running at a time"
  type        = number
  default     = 1
}

variable "efs_mountpoint" {
  description = "EFS mountpoint. default is /efs"
  type        = string
  default     = "/efs"
}

variable "custom_tags" {
  description = "custom tags"
  type        = map(any)
  default     = {}

}

