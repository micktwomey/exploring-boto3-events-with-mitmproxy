# Exploring boto3 Events With Mitmproxy

---
# Michael Twomey

- Hi! 👋 I'm Michael Twomey 🇮🇪
- Started my career in Sun Microsystems working on the Solaris OS in 1999 (when Y2K was a thing)
- 🐍 Been coding in Python for over 20 years
- Started kicking the tyres of AWS back when it was just S3, EC2 and SQS
- ☁️ Senior Cloud Architect at fourTheorem


---

/assets/fourTheorem-Logo-White.png
size: contain
/assets/fourtheorem-background.jpg
background: true
filter: darken
opacity: 50%

We are a pioneering technology consultancy focused on aws and serverless


---


/assets/awsbites website.png


You might also know us from AWS Bites, a weekly podcast with Eoin and Luciano


---

# AWS?
# boto3?
# mitmproxy?
# TLS?

- Going to go through a problem from beginning to end
- I'l show what issues I ran into and how I solved them
- Will try to give just enough explanation of everything I use
- There are many ways to achieve what I wanted, this is just one path!

Some tools I'll be using:
- A dash of AWS APIs
- Some boto3
- A bit of Python
- A pinch of HTTP
- A tiny bit of TLS
- A portion of mitmproxy

In short: how you combine tools to solve problems

---

# The Setup


---


/assets/renre-architecture.png
size: contain

Code base using Python and the boto3 library to talk to AWS

The core of the system runs a huge amount of computations spread over a large amount of jobs in either Lambda or Fargate containers

It wouldn't be unusual to have thousands of containers running many compute jobs per second.


---

# "A serverless architecture for high performance financial modelling"

/assets/qr-aws-hpc-blogpost.png
size: contain


For more details check out the post "A serverless architecture for high performance financial modelling"

https://aws.amazon.com/blogs/hpc/a-serverless-architecture-for-high-performance-financial-modelling/


---
/assets/renre-architecture-zoomed.png
size: contain

The bit to focus on for now is lots and lots of Fargate containers talking to S3

---

# The Problem:
## We got *the* question

---

	> "Why is my compute job so slow?"


During very large job runs we would occasionally see inexplicable slow downs and sometimes outright failures


---

# A clue in the logs
```http
HTTP/1.1 429 Rate limit exceeded
```


---
The Rate Limit Errors prompted the question:

# "Are we triggering a lot of S3 request retries?"

This could also equally apply to Kinesis or SQS or other APIs

---
# Request retries?
# Rate limits?

AWS has rate limits on their APIs (sensible!)


---

# S3 PUT object ~= 3,500 requests per second

S3 PUT object might have a rate limit of 3,500 requests per second [^2]

When you hit this you might get back a `HTTP 429` or `HTTP 503`

---

# boto3 tries to be helpful
```python
import boto3

s3 = boto2.client("s3")
response = s3.get_object(
  Bucket="example", Key="my-data"
)  # HTTP GET -> s3://example/my-data
```

boto3 attempts to handle this invisibly via retries[^3] to minimize impact on your application

[^2]: [https://docs.aws.amazon.com/AmazonS3/latest/userguide/optimizing-performance.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/optimizing-performance.html)

[^3]: [https://boto3.amazonaws.com/v1/documentation/api/latest/guide/retries.html#standard-retry-mode](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/retries.html#standard-retry-mode)


---

# boto3 Retry Mechanism


---

boto3's default retry handler[^4] implements the classic "retry with jitter" approach[^5]:

	1. For a known set of errors catch them
	2. Keep count of the number of times we've tried
	3. If we've hit a maximum retry count fail and allow the error to bubble up
	4. Otherwise take the count and multiply by some random number and some scale factor
	5. Sleep for that long
	6. Retry the call

[^4]: [https://github.com/boto/botocore/blob/develop/botocore/retryhandler.py](https://github.com/boto/botocore/blob/develop/botocore/retryhandler.py)

[^5]: [https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)


---

Retry sleep formula

```python
# From https://github.com/boto/botocore/blob/develop/botocore/retryhandler.py

base * (growth_factor ** (attempts - 1))

base = random.random()  # random float between 0.0 and 1.0
growth_factor = 2
attempts = 2
random.random() * (2 ** (2 - 1))
0.75 * 2 = 1.5

attempt 1 = 1 second max
attempt 2 = 2 second max
attempt 3 = 8 second max
attempt 4 = 16 second max
attempt 5 = 32 second max

# Default of 5 retries
32 + 16 + 8 + 2 + 1 = 59 seconds max sleep total, with 5x requests
```

Site note: note how it carefully adds up to less than 60 seconds. This is the default request timeout in many clients, servers and proxies.


---

# The Impact

TODO: Is this even relevant? Can I cut to save time? I think the total time sleeping is the most important part

Lots lots of calls per second * sleeping for a bunch of time = a big pile up

As more calls bunch up and sleep, we encounter more rate limits, leading to more calls...

Could this account for our stalls?


---

# How Can We Figure Out The Cause?

---

# Logging?
```python
logging.basicConfig(level=logging.DEBUG)
```

Could use logging at DEBUG level

This is super verbose and logs an overwhelming level of detail

What we want is some kind of hook to increment a count or emit a metric on retry

Does boto3 offer any hooks? 🤔
---

# Events?

Events[^6] are an extension mechanism for boto3


// ![inline fit](../images/boto3-events-docs.png)

[^6]: boto3 event docs over at [https://boto3.amazonaws.com/v1/documentation/api/latest/guide/events.html](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/events.html)

---

boto3 Events

You register a function to be called when an event matching a pattern happens.

Wildcards (`*`) are also allowed for patterns.


```python
"provide-client-params.s3.ListObjects"
"provide-client-params.s3.*"
"provide-client-params.*"
"*"
```

```python
s3 = boto3.client("s3")
s3.meta.events.register(
  "needs-retry.*", my_function
)
```


---

```python
import boto3

def print_event(event_name, **kwargs):
    print(event_name)

print("\nS3:")
s3 = boto3.client("s3")
s3.meta.events.register("*", print_event)
s3.list_buckets()

print("\nEC2:")
ec2 = boto3.client("ec2")
ec2.meta.events.register("*", print_event)
ec2.describe_instances()
```

---

```
S3:
provide-client-params.s3.ListBuckets
before-parameter-build.s3.ListBuckets
before-call.s3.ListBuckets
request-created.s3.ListBuckets
choose-signer.s3.ListBuckets
before-sign.s3.ListBuckets
before-send.s3.ListBuckets
response-received.s3.ListBuckets
needs-retry.s3.ListBuckets
after-call.s3.ListBuckets

EC2:
provide-client-params.ec2.DescribeInstances
before-parameter-build.ec2.DescribeInstances
before-call.ec2.DescribeInstances
request-created.ec2.DescribeInstances
choose-signer.ec2.DescribeInstances
before-sign.ec2.DescribeInstances
before-send.ec2.DescribeInstances
response-received.ec2.DescribeInstances
needs-retry.ec2.DescribeInstances
after-call.ec2.DescribeInstances
```


---
```python
import boto3
from rich import print

def print_event(event_name, **kwargs):
    print(event_name, kwargs)


s3 = boto3.client("s3")
s3.meta.events.register("*", print_event)

```

Python can capture keyword arguments (`foo="bar"`) into a variable using `**myvar`.

