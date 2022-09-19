import boto3
from rich import print


def print_event(event_name, **kwargs):
    print(event_name)


s3 = boto3.client("s3")
s3.meta.events.register("needs-retry.*", print_event)
s3.list_buckets()

ec2 = boto3.client("ec2")
ec2.meta.events.register("needs-retry.*", print_event)
ec2.describe_instances()
