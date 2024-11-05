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

variable "container_environment_variables" {
  description = "Environment variables of the container"
  type = list(map(string))
}