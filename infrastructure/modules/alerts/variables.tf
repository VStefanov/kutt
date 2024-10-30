variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

variable "resource_name_prefix" {
  description = "Resource name prefix (name of the project)"
  type        = string
}

variable "aler_subscriber_email" {
  description = "Email to subscribe to SNS topic"
  type = string
}

variable "aurora_cluster_id" {
  description = "ID of the Aurora cluster"
  type = string
}

variable "redis_cluster_id" {
  description = "ID of the ElastiCache Redis cluster"
  type = string
}

variable "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  type = string
}

variable "ecs_service_name" {
  description = "Name of the service within the ECS cluster"
  type = string
}
