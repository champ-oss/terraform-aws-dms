data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["dms:StartReplicationTask"]
    resources = [aws_dms_replication_task.this.replication_task_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "this" {
  name_prefix = var.git
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags
}