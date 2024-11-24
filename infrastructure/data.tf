data "aws_route53_zone" "this" {
  name = var.root_domain_name
}

data "aws_acm_certificate" "this" {
  domain = var.root_domain_name
  types  = ["AMAZON_ISSUED"]
}

# Fetch ECR from the secondary region
data "aws_ecr_repository" "secondary" {
  name = "${var.resource_name_prefix}-repository-${var.environment}"
}