output "global_replication_group_id" {
  description = "Global Replication Group ID"
  value       = try(aws_elasticache_global_replication_group.this[0].global_replication_group_id,null)
}

output "replication_group_primary_endpoint_address" {
   description = "Address of the endpoint for the primary node in the replication group"
   value       = try(aws_elasticache_replication_group.primary[0].primary_endpoint_address, null)
}

output "replication_group_reader_endpoint_address" {
   description = "Address of the endpoint for the primary node in the replication group"
   value       = try(aws_elasticache_replication_group.primary[0].reader_endpoint_address, null)
}