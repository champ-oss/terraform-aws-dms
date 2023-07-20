variable "git" {
  description = "Name of the Git repo"
  type        = string
  default     = "terraform-aws-dms"
}

variable "replication_task_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task.html#replication_task_id"
  type        = string
}

variable "migration_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task.html#migration_type"
  type        = string
  default     = "full-load"
}

variable "replication_instance_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task.html#replication_instance_arn"
  type        = string
}

variable "source_endpoint_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task.html#source_endpoint_arn"
  type        = string
}

variable "target_endpoint_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task.html#target_endpoint_arn"
  type        = string
}

variable "start_replication_task" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task.html#start_replication_task"
  type        = bool
  default     = false
}

variable "source_schema_name" {
  description = "Name of the schema in the source database"
  type        = string
  default     = "this"
}

variable "exclude_tables" {
  description = "List of tables names in the source database to exclude from syncing"
  type        = list(string)
  default     = []
}

variable "destination_schema_name" {
  description = "Name of the schema to write in the destination"
  type        = string
  default     = "this"
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "target_table_prep_mode" {
  description = "https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.FullLoad.html"
  type        = string
  default     = "DROP_AND_CREATE"
}

variable "enable_schedule" {
  description = "Run the replication task on a scheduled cron interval"
  type        = bool
  default     = true
}

variable "schedule" {
  description = "Cron schedule for the replication task"
  type        = string
  default     = "cron(0 9 * * ? *)"
}