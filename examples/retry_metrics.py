import boto3
from rich import print


def increment_metric(name):
    print(f"{name}|increment|count=1")


def handle_retry(event_name: str, attempts: int, **_):
    print("retry event?")
    if attempts > 1:
        increment_metric(event_name)
    else:
        print("nope!")


s3 = boto3.client("s3")
s3.meta.events.register("needs-retry.s3.*", handle_retry)
s3.list_buckets()
print("All done!")
