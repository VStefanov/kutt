variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "azs" {
  description = "A list of availability zones names or ids"
  type        = set(string)
}

variable "engine" {
  description = "Engine of the Aurora Global Cluster"
  type = string
  default = "aurora-postgresql"
}

variable "engine_version" {
  description = "Engine version of the Aurora Global Cluster"
  type = string
  default = "17.0"
}

variable "master_username" {
  description = "Database master username"
  type = string
}

variable "master_password" {
  description = "Database master password"
  type = string
}

variable "database_name" {
  description = "Database name"
  type = string
}

variable "instance_class" {
  description = "Database instance size"
  type = string
}

variable "vpc_subnet_ids" {
  description = "Aurora Cluster instance subnet IDs"
  type = set(string)
}

variable "security_groups" {
  description = "Aurora Cluster instance security groups"
  type = set(string)
}

variable "global_cluster_identifier" {
  description = "Aurora Global Cluster identifier"
  type = string
  default = null
}

variable "enable_global_write_forwarding" {
  description = "Enable write operations from reader to writer instance"
  type = bool
  default = false
}

variable "cluster_instance_count" {
  description = "Aurora Cluster instances count"
  type = number
  default = 1
}