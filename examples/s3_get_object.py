import boto3
import coloredlogs
import structlog

coloredlogs.install(level="INFO", fmt="%(asctime)s %(levelname)s %(name)s %(message)s")
log = structlog.get_logger()
log.info("starting")
s3 = boto3.client("s3")
bucket = "micktwomey-scratch-example"
key = "test/prefix1/ham/spam/foo.txt"
log.info("s3.get", key=key, bucket=bucket)
response = s3.get_object(Bucket=bucket, Key=key)
log.info("s3.response", key=key, bucket=bucket, response=response)
log.info("finished")
