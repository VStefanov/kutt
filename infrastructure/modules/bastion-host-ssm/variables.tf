variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the Bastion Host will be deployed"
  type = string
}

variable "security_groups" {
  description = "Bastion Host instance security groups"
  type = set(string)
}