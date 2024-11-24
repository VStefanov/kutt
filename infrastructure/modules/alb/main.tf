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
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_healthy_threshold
    unhealthy_threshold = var.health_unhealthy_threshold
    matcher             = var.health_response_status_code
    protocol            = var.health_protocol
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

resource "aws_lb_listener" "this_https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
