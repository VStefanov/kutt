variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = set(string)
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
  description = "Redis cluster subnet IDs"
  type = set(string)
}

variable "security_groups" {
  description = "Redis cluster security groups"
  type = set(string)
}
