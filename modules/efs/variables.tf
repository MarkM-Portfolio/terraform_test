variable "environment" {
  description = "Environment e.g. Prod, Dev, Staging and test"
  type        = string
}
variable "efs_name" {
  description = "globally unique name for the EFS"
  type        = string
}
variable "encrypted" {
  description = "If true, the disk will be encrypted."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
  type        = string
}
variable "performance_mode" {
  description = "The file system performance mode. Can be either generalPurpose or maxIO"
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned"
  type        = string
  default     = "bursting"
}

variable "security_group_ingress" {
  description = "A list of up to 5 VPC security group IDs (that must be for the same VPC as subnet specified) in effect for the mount target"

  # Example:
  # security_group_ingress = {
  #    default = {
  #      description = "Terraform created rule for NFS Inbound"
  #      from_port   = 2049
  #      protocol    = "tcp"
  #      to_port     = 2049
  #      self        = true
  #      cidr_blocks = ["10.20.0.0/16"]
  #    }
  #  }


  type = map(any)

}
variable "tags" {
  description = "custom tags"
  type        = map(any)
  default     = {}
}

variable "vpc_id" {
  type = string

}

variable "subnet_id" {
  description = "The ID of the subnet to add the mount target in"
  type        = list(string)

}
