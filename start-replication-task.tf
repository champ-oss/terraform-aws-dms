data "archive_file" "start_replication_task" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/start_replication_task.py"
  output_path      = "${path.module}/start_replication_task.zip"
}

module "this" {
  source                   = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.121-73d2ca1"
  git                      = var.git
  name                     = "${var.replication_task_id}-start"
  tags                     = merge(local.tags, var.tags)
  runtime                  = "python3.8"
  handler                  = "start_replication_task.lambda_handler"
  filename                 = data.archive_file.start_replication_task.output_path
  source_code_hash         = data.archive_file.start_replication_task.output_base64sha256
  enable_cw_event          = true
  schedule_expression      = "cron(0 14 * * ? *)"
  enable_custom_iam_policy = true
  custom_iam_policy_arn    = aws_iam_policy.this.arn
  environment = {
    REPLICATION_TASK_ARN = aws_dms_replication_task.this.replication_task_arn
  }
}