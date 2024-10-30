resource "aws_ecr_repository" "this" {
  name = "mbition-kutt-${var.environment}"
}