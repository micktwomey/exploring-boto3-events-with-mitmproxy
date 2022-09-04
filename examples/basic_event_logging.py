import boto3
from rich import print
import time


def print_event(event_name, **kwargs):
    print(event_name, kwargs)
    time.sleep(2.5)


s3 = boto3.client("s3")
s3.meta.events.register("*", print_event)
s3.list_buckets()
