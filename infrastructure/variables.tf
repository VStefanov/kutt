# Provider region vars
variable "primary_region" {
  description = "Primary region of the Aurora Global Cluster"
  type = string
  default = "eu-west-1"
}

variable "secondary_region" {
  description = "Secondary region of the Aurora Global Cluster"
  type = string
  default = "us-east-1"
}

# Primary VPC vars
variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "primary_vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "primary_public_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "primary_app_subnet_count" {
  description = "Number of app private subnets"
  type        = number
}

variable "primary_db_subnet_count" {
  description = "Number of db private subnets"
  type        = number
}

variable "primary_public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "primary_app_subnet_cidrs" {
  description = "CIDR blocks for app private subnets"
  type        = list(string)
}

variable "primary_db_subnet_cidrs" {
  description = "CIDR blocks for db private subnets"
  type        = list(string)
}

variable "primary_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

# Secondary VPC vars
variable "secondary_vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "secondary_public_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "secondary_app_subnet_count" {
  description = "Number of app private subnets"
  type        = number
}

variable "secondary_db_subnet_count" {
  description = "Number of db private subnets"
  type        = number
}

variable "secondary_public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "secondary_app_subnet_cidrs" {
  description = "CIDR blocks for app private subnets"
  type        = list(string)
}

variable "secondary_db_subnet_cidrs" {
  description = "CIDR blocks for db private subnets"
  type        = list(string)
}

variable "secondary_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}


# Redis vars
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

variable "db_engine" {
  description = "Database engine"
  type = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type = string
}

variable "cache_engine" {
  description = "ElastiCache engine"
  type = string
}

variable "cache_engine_version" {
  description = "ElastiCache engine version"
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
