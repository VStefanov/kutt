output "db_host" {
  value = aws_rds_cluster_instance.aurora_postgresql_writer.endpoint
}