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

variable "memory" {
  description = "Task memory"
  type = string
}

variable "cpu" {
  description = "Task cpu"
  type = string
}

variable "image" {
  description = "Task container image"
  type = string
}

variable "container_port" {
  description = "Container port"
  type = number
}

variable "host_port" {
  description = "Host port"
  type = number
}

variable "db_host" {
  description = "Database endpoint"
  type = string
}

variable "db_port" {
  description = "Database port"
  type = string
  default = "5432"
}

variable "app_domain_name" {
  description = "Kutt application domain name"
  type = string
}

variable "db_name" {
  description = "Name of the database"
  type = string
}

variable "db_user" {
  description = "Database username"
  type = string
}

variable "db_pass" {
  description = "Database password"
  type = string
}

variable "redis_host" {
  description = "Redis cache hostname"
  type = string
}

variable "redis_port" {
  description = "Redis port"
  type = string
  default = "6379"
}

variable "redis_password" {
  description = "Redis password"
  type = string
  default = ""
}

variable "vpc_subnet_ids" {
  description = "ECS cluster subnet ids"
  type = set(string)
}

variable "security_groups" {
  description = "ECS cluster security groups"
  type = set(string)
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB Target Group"
  type = string
}

variable "logs_retention_period" {
  description = "Retention period of the logs"
  type = number
  default = 7
}
