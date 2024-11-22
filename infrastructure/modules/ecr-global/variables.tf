variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "create_replication_group" {
  description = "Should we create ECR cross region replication group or not"
  type = bool
  default = false
}

variable "replication_group_region" {
  description = "Region of the ECR Replication Group"
  type = string
  default = ""
}
