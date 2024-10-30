resource "aws_rds_cluster" "aurora_postgresql" {
  cluster_identifier        = "${var.resource_name_prefix}-cluster-${var.environment}"
  engine                    = "aurora-postgresql"
  availability_zones        = var.azs
  master_username           = var.master_username
  master_password           = var.master_password
  database_name             = var.database_name
  vpc_security_group_ids    = var.security_groups
  db_subnet_group_name      = aws_db_subnet_group.aurora_postgresql_subnets.id
  skip_final_snapshot       = true

  backup_retention_period = 7
  preferred_backup_window = "05:00-07:00"

  lifecycle {
    ignore_changes = [
      availability_zones,
      cluster_identifier
    ]
  }
}

resource "aws_db_subnet_group" "aurora_postgresql_subnets" {
  name       = "${var.resource_name_prefix}-subnet-group-${var.environment}"
  subnet_ids = var.vpc_subnet_ids
}

resource "aws_rds_cluster_instance" "aurora_postgresql_writer" {
  identifier          = "${var.resource_name_prefix}-writer-instance-${var.environment}"
  cluster_identifier  = aws_rds_cluster.aurora_postgresql.id
  instance_class      = var.instance_class
  engine              = "aurora-postgresql"
  publicly_accessible = false
  promotion_tier      = 0
}

resource "aws_rds_cluster_instance" "aurora_postgresql_reader" {
  identifier          = "${var.resource_name_prefix}-reader-instance-${var.environment}"
  cluster_identifier  = aws_rds_cluster.aurora_postgresql.id
  instance_class      = var.instance_class
  engine              = "aurora-postgresql"
  publicly_accessible = false
  promotion_tier     = 1

  depends_on = [ aws_rds_cluster_instance.aurora_postgresql_writer ]
}

