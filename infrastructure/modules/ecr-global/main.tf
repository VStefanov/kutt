resource "aws_ecr_repository" "this" {
  name = "${var.resource_name_prefix}-repository-${var.environment}"
}

resource "aws_ecr_replication_configuration" "example" {
  count = var.create_replication_group ? 1 : 0
  
  replication_configuration {
    rule {  
      destination {
        region      = var.replication_group_region
        registry_id = data.aws_caller_identity.current.account_id
      }

      repository_filter {
        filter      = "${var.resource_name_prefix}"
        filter_type = "PREFIX_MATCH"
      }
    }
  }
}
