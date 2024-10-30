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

variable "route53_hosted_zone_name" {
  description = "Name of the Route53 Hosted Zone"
  type = string
}
