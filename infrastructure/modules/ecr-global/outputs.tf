output "repository_url" {
   description = "ECR Repository URL"
   value = aws_ecr_repository.this.repository_url
}

output "registry_id" {
   description = "ECR Registry ID"
   value = aws_ecr_repository.this.registry_id
}
