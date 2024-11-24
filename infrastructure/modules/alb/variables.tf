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

variable "vpc_id" {
  description = "ALB Target Group VPC ID"
  type = string
}

variable "security_groups" {
  description = "Redis cluster security groups"
  type = set(string)
}

variable "target_group_port" {
  description = "Port of the target group"
  type = number
  default = 3000
}

variable "health_check_path" {
  description = "URI path of the ALB health check"
  type = string
  default = "/"
}

variable "health_check_interval" {
  description = "Interval of the ALB health check"
  type = number
  default = 30
}

variable "health_check_timeout" {
  description = "Timeout of the ALB health check"
  type = number
  default = 5
}

variable "health_healthy_threshold" {
  description = "Healthy threshold of the ALB health check"
  type = number
  default = 2
}

variable "health_unhealthy_threshold" {
  description = "Unhealthy threshold of the ALB health check"
  type = number
  default = 3
}

variable "health_response_status_code" {
  description = "Status code of the health response endpoint"
  type = number
  default = 200
}

variable "health_protocol" {
  description = "Protocol of the ALB health check"
  type = string
  default = "HTTP"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate that will be associated to the ALB"
  type = string
}
