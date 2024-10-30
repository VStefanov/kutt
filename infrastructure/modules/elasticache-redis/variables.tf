variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "vpc_subnet_ids" {
  description = "Redis cluster subnet IDs"
  type = set(string)
}

variable "security_groups" {
  description = "Redis cluster security groups"
  type = set(string)
}

variable "node_type" {
  description = "Redis node type"
  type = string
}

variable "num_cache_nodes" {
  description = "Redis cache nodes number"
  type = number
}

variable "parameter_group_name" {
  description = "Redis parameter group name"
  type = string
}

variable "engine_version" {
  description = "Redis engine version"
  type = string
}

variable "logs_retention_period" {
  description = "Retention period of the logs"
  type = number
  default = 7
}
