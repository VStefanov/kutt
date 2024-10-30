resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.resource_name_prefix}-redis-cluster-${var.environment}"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  engine_version       = var.engine_version
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet.name
  security_group_ids   = var.security_groups
}

resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "${var.resource_name_prefix}-redis-subnet-group-${var.environment}"
  subnet_ids = var.vpc_subnet_ids
}

