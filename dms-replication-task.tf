locals {
  exclude_rules = [
    for tbl in toset(var.exclude_tables) : {
      rule-type = "selection",
      rule-id   = random_string.this[tbl].result,
      rule-name = random_string.this[tbl].result,
      object-locator = {
        schema-name = var.source_schema_name,
        table-name  = tbl
      },
      rule-action = "exclude",
      filters     = []
    }
  ]
}

resource "aws_dms_replication_task" "this" {
  replication_task_id      = var.replication_task_id
  migration_type           = var.migration_type
  replication_instance_arn = var.replication_instance_arn
  source_endpoint_arn      = var.source_endpoint_arn
  target_endpoint_arn      = var.target_endpoint_arn
  start_replication_task   = var.start_replication_task
  tags                     = merge(local.tags, var.tags)

  table_mappings = jsonencode(
    {
      "rules" : concat(local.exclude_rules,
        [
          {
            rule-type = "selection",
            rule-id   = random_string.this["include"].result,
            rule-name = random_string.this["include"].result,
            object-locator = {
              "schema-name" = var.source_schema_name,
              "table-name"  = "%"
            },
            rule-action = "include",
            filters     = []
          },
          {
            rule-type   = "transformation",
            rule-id     = random_string.this["rename"].result,
            rule-name   = random_string.this["rename"].result,
            rule-target = "schema",
            object-locator = {
              "schema-name" = var.source_schema_name
            },
            rule-action = "rename",
            value       = var.destination_schema_name,
            old-value   = null
          },
      ])
    }
  )

  replication_task_settings = jsonencode(
    {
      "TargetMetadata" : {
        "TargetSchema" : "",
        "SupportLobs" : true,
        "FullLobMode" : true,
        "LobChunkSize" : 64,
        "LimitedSizeLobMode" : false,
        "LobMaxSize" : 0,
        "InlineLobMaxSize" : 0,
        "LoadMaxFileSize" : 0,
        "ParallelLoadThreads" : 0,
        "ParallelLoadBufferSize" : 0,
        "BatchApplyEnabled" : false,
        "TaskRecoveryTableEnabled" : false,
        "ParallelLoadQueuesPerThread" : 0,
        "ParallelApplyThreads" : 0,
        "ParallelApplyBufferSize" : 0,
        "ParallelApplyQueuesPerThread" : 0
      },
      "FullLoadSettings" : {
        "TargetTablePrepMode" : "DROP_AND_CREATE",
        "CreatePkAfterFullLoad" : false,
        "StopTaskCachedChangesApplied" : true,
        "StopTaskCachedChangesNotApplied" : false,
        "MaxFullLoadSubTasks" : 5,
        "TransactionConsistencyTimeout" : 0,
        "CommitRate" : 10000
      },
      "Logging" : {
        "EnableLogging" : true,
        "LogComponents" : [
          {
            "Id" : "TRANSFORMATION",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "SOURCE_UNLOAD",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "IO",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "TARGET_LOAD",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "PERFORMANCE",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "SOURCE_CAPTURE",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "SORTER",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "REST_SERVER",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "VALIDATOR_EXT",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "TARGET_APPLY",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "TASK_MANAGER",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "TABLES_MANAGER",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "METADATA_MANAGER",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "FILE_FACTORY",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "COMMON",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "ADDONS",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "DATA_STRUCTURE",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "COMMUNICATION",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          },
          {
            "Id" : "FILE_TRANSFER",
            "Severity" : "LOGGER_SEVERITY_DEFAULT"
          }
        ],
      },
      "ControlTablesSettings" : {
        "ControlSchema" : "",
        "HistoryTimeslotInMinutes" : 5,
        "HistoryTableEnabled" : false,
        "SuspendedTablesTableEnabled" : false,
        "StatusTableEnabled" : false,
        "FullLoadExceptionTableEnabled" : false
      },
      "StreamBufferSettings" : {
        "StreamBufferCount" : 3,
        "StreamBufferSizeInMB" : 8,
        "CtrlStreamBufferSizeInMB" : 5
      },
      "ChangeProcessingDdlHandlingPolicy" : {
        "HandleSourceTableDropped" : true,
        "HandleSourceTableTruncated" : true,
        "HandleSourceTableAltered" : true
      },
      "ErrorBehavior" : {
        "DataErrorPolicy" : "STOP_TASK",
        "EventErrorPolicy" : "STOP_TASK",
        "DataTruncationErrorPolicy" : "STOP_TASK",
        "DataErrorEscalationPolicy" : "STOP_TASK",
        "DataErrorEscalationCount" : 0,
        "TableErrorPolicy" : "STOP_TASK",
        "TableErrorEscalationPolicy" : "STOP_TASK",
        "TableErrorEscalationCount" : 0,
        "RecoverableErrorCount" : -1,
        "RecoverableErrorInterval" : 5,
        "RecoverableErrorThrottling" : true,
        "RecoverableErrorThrottlingMax" : 1800,
        "RecoverableErrorStopRetryAfterThrottlingMax" : true,
        "ApplyErrorDeletePolicy" : "STOP_TASK",
        "ApplyErrorInsertPolicy" : "STOP_TASK",
        "ApplyErrorUpdatePolicy" : "STOP_TASK",
        "ApplyErrorEscalationPolicy" : "STOP_TASK",
        "ApplyErrorEscalationCount" : 0,
        "ApplyErrorFailOnTruncationDdl" : true,
        "FullLoadIgnoreConflicts" : true,
        "FailOnTransactionConsistencyBreached" : true,
        "FailOnNoTablesCaptured" : true
      },
      "ChangeProcessingTuning" : {
        "BatchApplyPreserveTransaction" : true,
        "BatchApplyTimeoutMin" : 1,
        "BatchApplyTimeoutMax" : 30,
        "BatchApplyMemoryLimit" : 500,
        "BatchSplitSize" : 0,
        "MinTransactionSize" : 1000,
        "CommitTimeout" : 1,
        "MemoryLimitTotal" : 1024,
        "MemoryKeepTime" : 60,
        "StatementCacheSize" : 50
      },
      "PostProcessingRules" : null,
      "CharacterSetSettings" : null,
      "LoopbackPreventionSettings" : null,
      "BeforeImageSettings" : null,
      "FailTaskWhenCleanTaskResourceFailed" : false,
      "TTSettings" : null
    }
  )
}