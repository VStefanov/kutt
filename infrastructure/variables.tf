# VPC vars
variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "app_subnet_count" {
  description = "Number of app private subnets"
  type        = number
}

variable "db_subnet_count" {
  description = "Number of db private subnets"
  type        = number
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for app private subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for db private subnets"
  type        = list(string)
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

# Redis vars
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

# Aurora PostgreSQL vars
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

# Application vars
variable "image_tag" {
  description = "Tag of the container image"
  type = string
  default = "latest"
}

variable "app_domain_name" {
  description = "Domain name of the running application"
  type = string
}

variable "route53_hosted_zone_name" {
  description = "Name of the Route53 Hosted Zone"
  type = string
}
