

# Aurora Primary Cluster
resource "aws_rds_cluster" "this" {
  cluster_identifier          = "${var.resource_name_prefix}-cluster-${var.environment}"
  engine                      = var.engine
  engine_version              = var.engine_version
  global_cluster_identifier   = var.global_cluster_identifier
  availability_zones          = var.azs
  master_username             = var.master_username
  master_password             = var.master_password
  database_name               = var.database_name
  vpc_security_group_ids      = var.security_groups
  port                        = var.port

  enable_global_write_forwarding = var.enable_global_write_forwarding

  db_subnet_group_name      = aws_db_subnet_group.this.id
  skip_final_snapshot       = true

  enabled_cloudwatch_logs_exports = [ "postgresql" ]

  backup_retention_period = 7
  preferred_backup_window = "05:00-07:00"

  lifecycle {
    ignore_changes = [
      availability_zones,
      cluster_identifier
    ]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.resource_name_prefix}-subnet-group-${var.environment}"
  subnet_ids = var.vpc_subnet_ids
}

resource "aws_rds_cluster_instance" "this" {
  count               = var.cluster_instance_count
  identifier          = "${var.resource_name_prefix}-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.this.id
  instance_class      = var.instance_class
  engine              = var.engine
  engine_version      = var.engine_version
  publicly_accessible = false
}