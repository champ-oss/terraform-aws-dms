import boto3
import os

DMS = boto3.client('dms')
REPLICATION_TASK_ARN = os.getenv('REPLICATION_TASK_ARN')


def lambda_handler(_, __):
    response = DMS.start_replication_task(
        ReplicationTaskArn=REPLICATION_TASK_ARN,
        StartReplicationTaskType='reload-target',
    )
    print(response)