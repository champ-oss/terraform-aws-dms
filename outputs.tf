output "replication_task_arn" {
  value = aws_dms_replication_task.this.replication_task_arn
}

output "replication_instance_arn" {
  value = aws_dms_replication_task.this.replication_instance_arn
}

output "source_endpoint_arn" {
  value = aws_dms_replication_task.this.source_endpoint_arn
}

output "migration_type" {
  value = aws_dms_replication_task.this.migration_type
}

output "replication_task_id" {
  value = aws_dms_replication_task.this.replication_task_id
}

output "target_endpoint_arn" {
  value = aws_dms_replication_task.this.target_endpoint_arn
}
