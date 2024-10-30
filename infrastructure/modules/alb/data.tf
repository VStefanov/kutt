data "aws_acm_certificate" "this" {
  domain      = "${var.environment}.${var.route53_hosted_zone_name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "this" {
  name = "${var.route53_hosted_zone_name}"
}
