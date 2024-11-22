resource "aws_elasticache_replication_group" "primary" {
  count                       = var.create_primary_global_replication_group ? 1 : 0
  description                = "Primary Replication Group for Global Datastore"
  replication_group_id       = "${var.resource_name_prefix}-${var.environment}"
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_clusters
  engine                     = var.engine
  engine_version             = var.engine_version
  automatic_failover_enabled = true
  security_group_ids         = var.security_groups
  port                       = var.port
  parameter_group_name       = var.parameter_group_name
  subnet_group_name          = aws_elasticache_subnet_group.this.name

  preferred_cache_cluster_azs = var.azs

  transit_encryption_enabled = true
  at_rest_encryption_enabled = true

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.this.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  snapshot_retention_limit = 7
  snapshot_window          = "05:00-07:00"
}

resource "aws_elasticache_global_replication_group" "this" {
  count                              = var.create_primary_global_replication_group ? 1 : 0
  global_replication_group_id_suffix = "global-cluster"
  
  primary_replication_group_id       = aws_elasticache_replication_group.primary[0].id
}

resource "aws_elasticache_replication_group" "secondary" {
  count                       = var.create_secondary_global_replication_group ? 1 : 0
  replication_group_id        = "${var.resource_name_prefix}-${var.environment}"
  description                 =  "Secondary Replication Group for Global Datastore"
  global_replication_group_id = var.global_replication_group_id
  subnet_group_name           = aws_elasticache_subnet_group.this.name
  num_cache_clusters          = var.num_cache_clusters

  preferred_cache_cluster_azs = var.azs

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.this.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.resource_name_prefix}-subnet-group-${var.environment}"
  subnet_ids = var.vpc_subnet_ids
}


resource "aws_cloudwatch_log_group" "this" {
  name              = "/elastichahe/${var.resource_name_prefix}-logs-${var.environment}"
  retention_in_days = var.logs_retention_period
}