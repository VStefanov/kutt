output "instance_id" {
  description = "ID of the Bastion Host instance"
  value = aws_instance.this.id
}