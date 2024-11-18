resource "aws_route53_health_check" "this" {
  fqdn                           = var.alb_dns
  type                           = var.health_check_type
  resource_path                  = var.health_check_resource_path
  failure_threshold              = 3
  request_interval               = 30
}

resource "aws_route53_record" "this" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.this.id
  failover_routing_policy {
    type = var.failover_policy_type
  }
}
