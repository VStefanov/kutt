resource "aws_lb" "this" {
  name               = "${var.resource_name_prefix}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.vpc_subnet_ids
  security_groups    = var.security_groups
}

resource "aws_lb_target_group" "this" {
  name        = "${var.resource_name_prefix}-tg-${var.environment}"
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = 302
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn   = data.aws_acm_certificate.this.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name     = "${var.environment}.${var.route53_hosted_zone_name}"
  type     = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
