import boto3
from rich import print


def print_event(event_name: str, attempts: int, response, **kwargs):
    print(
        event_name,
        attempts,
        response[1]["ResponseMetadata"]["HTTPStatusCode"],
    )


s3 = boto3.client("s3")
s3.meta.events.register("needs-retry.s3.ListBuckets", print_event)
try:
    s3.list_buckets()
except Exception as e:
    print
