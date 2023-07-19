terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

data "aws_region" "current" {}

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "this" {
  tags = {
    purpose = "vega"
    Type    = "Private"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

resource "aws_dms_endpoint" "source" {
  endpoint_id   = "terraform-aws-dms-source"
  endpoint_type = "source"
  engine_name   = "aurora"
  database_name = "this"
  password      = "password"
  port          = 3306
  server_name   = "test"
  username      = "user"

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "aws_dms_endpoint" "target" {
  endpoint_id   = "terraform-aws-dms-target"
  endpoint_type = "target"
  engine_name   = "aurora"
  database_name = "this"
  password      = "password"
  port          = 3306
  server_name   = "test"
  username      = "user"

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "aws_dms_replication_subnet_group" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.amazon_dms_cloudwatch_logs_role,
    aws_iam_role_policy_attachment.amazon_dms_vpc_management_role
  ]
  replication_subnet_group_description = "terraform-aws-dms"
  replication_subnet_group_id          = "terraform-aws-dms"
  subnet_ids                           = data.aws_subnets.this.ids
}

resource "aws_dms_replication_instance" "this" {
  allocated_storage            = 50
  allow_major_version_upgrade  = true
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  engine_version               = "3.5.1"
  multi_az                     = false
  preferred_maintenance_window = "sun:17:00-sun:20:00"
  publicly_accessible          = false
  replication_instance_class   = "dms.t3.micro"
  replication_instance_id      = "terraform-aws-dms"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.this.id
}

module "this" {
  source             = "../../"
  replication_task_id = "dms-test"
  replication_instance_arn = aws_dms_replication_instance.this.replication_instance_arn
  source_endpoint_arn = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.target.endpoint_arn
  destination_schema_name = "dms-test"
  exclude_tables = [
    "test1_%",
    "test2_%"
  ]
}