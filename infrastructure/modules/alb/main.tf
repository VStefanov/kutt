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
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
