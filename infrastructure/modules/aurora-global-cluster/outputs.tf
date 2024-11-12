output "writer_endpoint" {
  description = "Writer endpoint of the Aurora Global Database"
  value = try(aws_rds_cluster.this.endpoint, null)
}

output "reader_endpoint" {
  description = "Reader endpoint of the Aurora Global Database"
  value = try(aws_rds_cluster.this.reader_endpoint, null)
}