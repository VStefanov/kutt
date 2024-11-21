variable "domain_name" {
  description = "The domain name for the Route 53 records"
  type = string
}

variable "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for the domain"
  type = string
}

variable "alb_dns" {
  description = "DNS name of the ALB"
  type = string
}

variable "alb_zone_id" {
  description = "Zone Id of the ALB"
  type = string
}

variable "failover_policy_type" {
  description = "Failover Routing Policy type"
  type = string
  default = "PRIMARY"
}

variable "health_check_type" {
  description = "The protocol to use when performing health checks"
  type = string
  default = "HTTP"
}

variable "health_check_resource_path" {
  description = "The path that you want Amazon Route 53 to request when performing health checks"
  type = string
  default = "/"
}

variable "record_identifier" {
  description = "Unique identifier to differentiate records with routing policies from one another"
  type = string
}