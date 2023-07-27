output "replication_task_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/3.8.0/docs/resources/dms_replication_task"
  value       = aws_dms_replication_task.this.replication_task_arn
}

output "replication_instance_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/3.8.0/docs/resources/dms_replication_task"
  value       = aws_dms_replication_task.this.replication_instance_arn
}

output "source_endpoint_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/3.8.0/docs/resources/dms_replication_task"
  value       = aws_dms_replication_task.this.source_endpoint_arn
}

output "migration_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/3.8.0/docs/resources/dms_replication_task"
  value       = aws_dms_replication_task.this.migration_type
}

output "replication_task_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/3.8.0/docs/resources/dms_replication_task"
  value       = aws_dms_replication_task.this.replication_task_id
}

output "target_endpoint_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/3.8.0/docs/resources/dms_replication_task"
  value       = aws_dms_replication_task.this.target_endpoint_arn
}
