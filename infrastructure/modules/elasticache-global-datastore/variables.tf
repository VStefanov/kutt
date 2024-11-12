variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "vpc_subnet_ids" {
  description = "Redis Global Datastore instance subnet IDs"
  type = set(string)
}

variable "security_groups" {
  description = "Redis Global Datastore instance security groups"
  type = set(string)
}

variable "node_type" {
  description = "Redis node type"
  type = string
}

variable "num_cache_clusters" {
  description = "ElastiCache cluster number"
  type = number
}

variable "parameter_group_name" {
  description = "Redis parameter group name"
  type = string
}

variable "engine" {
  description = "ElastiCache engine"
  type = string
}

variable "engine_version" {
  description = "ElastiCache engine version"
  type = string
}

variable "logs_retention_period" {
  description = "Retention period of the logs"
  type = number
  default = 7
}

variable "global_replication_group_id" {
  description = "The ID of the global replication group to which this replication group should belong"
  type        = string
  default     = null
}

variable "create_primary_global_replication_group" {
  description = "Determines whether an primary ElastiCache global replication group will be created"
  type = bool
  default = false
}

variable "create_secondary_global_replication_group" {
  description = "Determines whether an secondary ElastiCache global replication group will be created"
  type = bool
  default = false
}
