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

# AWS Bites
/assets/awsbites website.png
size: contain
/assets/awsbites.png
size: contain


You might also know us from AWS Bites, a weekly podcast with Eoin and Luciano


---


# I'll be talking about solving a problem

- Going to go through a problem from beginning to end
- I'l show what issues I ran into and how I solved them
- Will try to give just enough explanation of everything I use
- There are many ways to achieve what I wanted, this is just one path!


---

# AWS S3 ☁️

# boto3 🐍
# Python 🐍

# mitmproxy 🔨

# HTTP 🌍
# TLS 🔒


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

Before I talk about the problem I need to talk a little bit about the system and how the relevant parts of it work.

---


/assets/renre-architecture.png
size: contain

Code base using Python and the boto3 library to talk to AWS

The core of the system runs a huge amount of computations spread over a large amount of jobs in either Lambda or Fargate containers

It wouldn't be unusual to have thousands of containers running many compute jobs per second.

Typically talking about tens of thousands to millions of jobs in each run.

The majority of orchestration and compute is run using AWS infrastructure such as step functions, lambdas, fargate containers and SQS queues.

---
/assets/renre-architecture-zoomed.png
size: contain

The bit to focus on for now is lots and lots of Fargate containers talking to S3

---


/assets/dag.png
size: contain
---
/assets/containers.png
size: contain
---

# "A serverless architecture for high performance financial modelling"
## https://aws.amazon.com/blogs/hpc/a-serverless-architecture-for-high-performance-financial-modelling/
/assets/qr-aws-hpc-blogpost.png
size: contain


For more details check out the post "A serverless architecture for high performance financial modelling"

https://aws.amazon.com/blogs/hpc/a-serverless-architecture-for-high-performance-financial-modelling/

---

What does a compute job look like?

```python
import boto3

s3 = boto2.client("s3")
for input in stuff_to_process:
  # HTTP GET https://example.s3.eu-west-1.amazonaws.com/my-input-data
  response = s3.get_object(
    Bucket="example", Key="my-input-data"
  )
  data = do_stuff_with_input(response)
  # HTTP PUT https://example.s3.eu-west-1.amazonaws.com/my-output-data
  response = s3.put_object(
    Bucket="example", Key="my-output-data", Body=data
  )
  # Fancier: multi-part upload with threaded transfer manager
  s3.upload_fileobj(data, 'example', 'my-output-data')
```

Basically every worker does some combination of this

Read data (sometimes lots of S3 keys), process, then write output to S3 (sometimes lots of S3 keys).

For larger objects we use the transfer manager which splits the object into lots of smaller chunks and uploads or downloads in parallel.

---


# The Problem:
## We got one of the dreaded questions

---

	> "Why is my compute job so slow?"


During very large job runs we would occasionally see inexplicable slow downs and sometimes outright failures

We did the usual and checked our dashboards and alarms, nothing stood out.

---

# A clue in the logs
```python
Traceback (most recent call last):
  File "...examples/s3_get_object.py", line 12, in <module>
    response = s3.get_object(Bucket=bucket, Key=key)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "...botocore/client.py", line 535, in _api_call
    return self._make_api_call(operation_name, kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "...botocore/client.py", line 980, in _make_api_call
    raise error_class(parsed_response, operation_name)
botocore.exceptions.ClientError: An error occurred (429) when calling the GetObject operation (reached max retries: 4): Too Many Requests
```


Note that frequently we'd have a slow run but none of these errors. So no indication what was happening until we saw the errors.

---

The Rate Limit Errors prompted the question:

# "Are we triggering a lot of S3 request retries?"

This could also equally apply to Kinesis or SQS or other APIs

---

# Request retries?
# Rate limits?
## Isn't the cloud infinite?

AWS has rate limits on their APIs (sensible!)


---

# S3 PUT object

# 3,500 requests per second

S3 PUT object might have a rate limit of 3,500 requests per second [^2]

When you hit this you might get back a `HTTP 429` or `HTTP 503`

---

# boto3 tries to be helpful
```python
import boto3

s3 = boto2.client("s3")
# Implicitly retries, blocking:
response = s3.get_object(...)
```

boto3 attempts to handle this invisibly via retries[^3] to minimize impact on your application

[^2]: [https://docs.aws.amazon.com/AmazonS3/latest/userguide/optimizing-performance.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/optimizing-performance.html)

[^3]: [https://boto3.amazonaws.com/v1/documentation/api/latest/guide/retries.html#standard-retry-mode](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/retries.html#standard-retry-mode)


---

# Digression: boto3 Retry Mechanism


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

random.random() * (growth_factor ** (attempts - 1))
0.75 * (2 ** (2 - 1)) = 1.5

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

# Theory: Even though we mostly eventually succeed, we take a really long time doing stuff


---

# Where We Are
	1. Got some jobs taking a long time
	2. Guessed it's retries causing this
	3. ??

---

# How Can We Be Sure it's Retrying?

---

# Logging?
```python
logging.basicConfig(level=logging.DEBUG)
```

Could use logging at DEBUG level

---

```
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-parameter-build.s3.GetObject: calling handler <function sse_md5 at 0x110d3f920>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-parameter-build.s3.GetObject: calling handler <function validate_bucket_name at 0x110d3f880>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-parameter-build.s3.GetObject: calling handler <function remove_bucket_from_url_paths_from_model at 0x110d5d9e0>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-parameter-build.s3.GetObject: calling handler <bound method S3RegionRedirectorv2.annotate_request_context of <botocore.utils.S3RegionRedirectorv2 object at 0x114319fd0>>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-parameter-build.s3.GetObject: calling handler <function generate_idempotent_uuid at 0x110d3f6a0>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-endpoint-resolution.s3: calling handler <function customize_endpoint_resolver_builtins at 0x110d5dbc0>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-endpoint-resolution.s3: calling handler <bound method S3RegionRedirectorv2.redirect_from_cache of <botocore.utils.S3RegionRedirectorv2 object at 0x114319fd0>>
2023-11-07 12:05:04 DEBUG botocore.regions Calling endpoint provider with parameters: {'Bucket': 'micktwomey-scratch-example', 'Region': 'eu-west-1', 'UseFIPS': False, 'UseDualStack': False, 'ForcePathStyle': False, 'Accelerate': False, 'UseGlobalEndpoint': False, 'DisableMultiRegionAccessPoints': False, 'UseArnRegion': True}
2023-11-07 12:05:04 DEBUG botocore.regions Endpoint provider result: https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com
2023-11-07 12:05:04 DEBUG botocore.regions Selecting from endpoint provider's list of auth schemes: "sigv4". User selected auth scheme is: "None"
2023-11-07 12:05:04 DEBUG botocore.regions Selected auth type "v4" as "v4" with signing context params: {'region': 'eu-west-1', 'signing_name': 's3', 'disableDoubleEncoding': True}
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-call.s3.GetObject: calling handler <function add_expect_header at 0x110d3fc40>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-call.s3.GetObject: calling handler <function add_recursion_detection_header at 0x110d3df80>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-call.s3.GetObject: calling handler <function inject_api_version_header_if_needed at 0x110d5d1c0>
2023-11-07 12:05:04 DEBUG botocore.endpoint Making request for OperationModel(name=GetObject) with params: {'url_path': '/test/prefix1/ham/spam/foo.txt', 'query_string': {}, 'method': 'GET', 'headers': {'User-Agent': 'Boto3/1.28.79 md/Botocore#1.31.79 ua/2.0 os/macos#23.0.0 md/arch#x86_64 lang/python#3.11.5 md/pyimpl#CPython cfg/retry-mode#legacy Botocore/1.31.79'}, 'body': b'', 'auth_path': '/micktwomey-scratch-example/test/prefix1/ham/spam/foo.txt', 'url': 'https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt', 'context': {'client_region': 'eu-west-1', 'client_config': <botocore.config.Config object at 0x114319550>, 'has_streaming_input': False, 'auth_type': 'v4', 's3_redirect': {'redirected': False, 'bucket': 'micktwomey-scratch-example', 'params': {'Bucket': 'micktwomey-scratch-example', 'Key': 'test/prefix1/ham/spam/foo.txt'}}, 'signing': {'region': 'eu-west-1', 'signing_name': 's3', 'disableDoubleEncoding': True}}}
2023-11-07 12:05:04 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <bound method RequestSigner.handler of <botocore.signers.RequestSigner object at 0x114319510>>
2023-11-07 12:05:04 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <bound method ClientCreator._default_s3_presign_to_sigv2 of <botocore.client.ClientCreator object at 0x110e138d0>>
2023-11-07 12:05:04 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <function set_operation_specific_signer at 0x110d3f560>
2023-11-07 12:05:04 DEBUG botocore.hooks Event before-sign.s3.GetObject: calling handler <function remove_arn_from_signing_path at 0x110d5db20>
2023-11-07 12:05:04 DEBUG botocore.auth Calculating signature using v4 auth.
2023-11-07 12:05:04 DEBUG botocore.auth CanonicalRequest:
GET
/test/prefix1/ham/spam/foo.txt

host:micktwomey-scratch-example.s3.eu-west-1.amazonaws.com
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20231107T120504Z
x-amz-security-token:...

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
2023-11-07 12:05:04 DEBUG botocore.auth StringToSign:
AWS4-HMAC-SHA256
20231107T120504Z
20231107/eu-west-1/s3/aws4_request
4b4ea6ab346ff7949f47a10a3bf46a9169749520d75a30696b0fff2c077eb7a2
2023-11-07 12:05:04 DEBUG botocore.auth Signature:
30dfcec555fb14f449a78972ecd2063c76b5c93a70f5ef5a6a16e52aed405b79
2023-11-07 12:05:04 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <function add_retry_headers at 0x110d5d940>
2023-11-07 12:05:04 DEBUG botocore.endpoint Sending http request: <AWSPreparedRequest stream_output=True, method=GET, url=https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt, headers={'User-Agent': b'Boto3/1.28.79 md/Botocore#1.31.79 ua/2.0 os/macos#23.0.0 md/arch#x86_64 lang/python#3.11.5 md/pyimpl#CPython cfg/retry-mode#legacy Botocore/1.31.79', 'X-Amz-Date': b'20231107T120504Z', 'X-Amz-Security-Token': b'...', 'X-Amz-Content-SHA256': b'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Authorization': b'AWS4-HMAC-SHA256 Credential=ASIAVYOFBVCIGIENLWHC/20231107/eu-west-1/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token, Signature=30dfcec555fb14f449a78972ecd2063c76b5c93a70f5ef5a6a16e52aed405b79', 'amz-sdk-invocation-id': b'ccde3a33-bb84-4e1a-8d96-8dca5603675e', 'amz-sdk-request': b'attempt=1'}>
```

DEBUG logging in boto3 hugely verbose, unusuble in most situations.

Particularly unsusable for us, this would likely generate a TiB of logs!

If only there was some kind of hook or event we could use...

---

# Events?

Events[^6] are an extension mechanism for boto3


// ![inline fit](../images/boto3-events-docs.png)

[^6]: boto3 event docs over at [https://boto3.amazonaws.com/v1/documentation/api/latest/guide/events.html](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/events.html)


---

```python

event_hooks = []

def event_emitting_call(arg):
   # ... do some work
   for hook in event_hooks:
     hook(("event", arg))

def register(callable):
  event_hooks.append(callable)

register(print)
event_emitting_call("hello")
# prints ("event", "hello")
```

This is an exampe of how you could implement events in python.

The core idea is you have hooks in your library code which can call handlers with some data. In some cases the hooks could modify data too.

As a user you can register your own functions to react to these events.

---

boto3 Events

You register a function to be called when an event matching a pattern happens.

Wildcards (`*`) are also allowed for patterns.

```python
s3 = boto3.client("s3")
s3.meta.events.register(
  "needs-retry.*", my_function
)
```

```python
"provide-client-params.s3.ListObjects"
"provide-client-params.s3.*"
"provide-client-params.*"
"*"
```

Annoyance: even though you specify s3 in the event name you still have to use a s3 specific event register call. Vice versa, why have s3 in the name if using a specific call.

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

Here you can see the code to print out all events received by s3 list_buckets and ec2 describe_instances
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

Here you can see all the events which get triggered
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

This is way more useful, now you are getting arguments too!


---
```python
provide-client-params.s3.ListBuckets
{
    'params': {},
    'model': OperationModel(name=ListBuckets),
    'context': {
        'client_region': 'eu-west-1',
        'client_config': <botocore.config.Config>,
        'has_streaming_input': False,
        'auth_type': None
    }
}
```


---

```python
request-created.s3.ListBuckets
{
    'request': <botocore.awsrequest.AWSRequest>,
    'operation_name': 'ListBuckets'
}
```


---

# 🤔
```python
needs-retry.s3.ListBuckets
{
    'response': (
        <botocore.awsrequest.AWSResponse>,
        {
            'ResponseMetadata': {
                'RequestId': 'QZV9EWHJMR4T8VQ9',
    ...
    'endpoint': s3(https://s3.eu-west-1.amazonaws.com),
    'operation': OperationModel(name=ListBuckets),
    'attempts': 1,
    'caught_exception': None,
    'request_dict': {
        'url_path': '/',
        'query_string': '',
        'method': 'GET',
    ...
}
```


---

```python
needs-retry.s3.ListBuckets
...
'attempts': 1,
'caught_exception': None,
...
```

This looks really promising. Doest that attempts count go up?

Is this documented anywhere? Nope!


---

# We have an event to watch but we don't know what failure looks like

---

# No Documentation of needs-retry.s3.ListBuckets Event 😭


---
# Where We Are
	1. Got some jobs taking a long time
	2. Guessed it's retries causing this
	3. Want to use events to monitor these but don't have docs
	4. ??


---
# How do we figure out what the event looks like for real?

---

# 1. Triggering the rate limit for real 💸

# 2. Hacking the library 📚

# 3. Hacking Python 🐍

# 4. Hacking the OS 👩‍💻

# 5. Hacking the network 🌐

Semi realistic, the code will behave as it would if this really happened

This is the one I chose.

---
# HTTP: The Bits We Care About
# Client Request 💻→☁️
```http
GET /cat.jpeg HTTP/1.1
Host: example.s3.eu-west-2.amazonaws.com
...
```

# Server Response 💻←🐱
```http
HTTP/1.1 200 OK
Content-Type: image/jpeg
...
```

---


# Hacking HTTP


## Bet: boto3 looks at the HTTP response code

## Bet: AWS uses "429 Too Many Requests" for rate limits

## Bet: boto3 ignores everything except that 429


- For a rate limit I'm betting boto3 looks at the HTTP response code
- I'm also betting it'll be HTTP 429
- I'm also betting the code doesn't care about the payload too much once it's a 429
- Finally I'm betting boto3 doesn't verify a response checksum


---

/assets/geordi-error-free-to-busted.jpg
size: contain


# From Success 😭
```javascript
HTTP/1.1 200 OK
Content-Length: 34202
Content-Type: application/json
...
{
  ...
}
```

# To Failure! 🙃
```javascript
HTTP/1.1 429 Rate limit exceeded
Content-Length: 34202
Content-Type: application/json;
...
{
  ...
}
```

We're only changing one part of the response, so should be easy to implement.

Right?


---

# Where We Are
	1. Got some jobs taking a long time
	2. Guessed it's retries causing this
	3. Want to use events to monitor these but don't have docs
	4. Want to somehow modify responses to simulate retries and see what happens
	5. ??


---

# How: mitmproxy
	https://mitmproxy.org
	> mitmproxy is a free and open source interactive HTTPS proxy.


/assets/mitmproxy.png
size: contain


What?

Let's you mess with the HTTP requests and responses from programs

Bit like Chrome Dev Tools for all your HTTP speaking commands


---

	1. Run `mitmproxy` (or `mitmweb` for a fancier web interface)
	2. Set the HTTP proxy settings to mitmproxy's (defaults to http://localhost:8080)
	3. Run your program
	4. Watch in mitmproxy

Easy right?

---
# HTTP GET Example
```python
import httpx

httpx.get("http://httpbin.org/get")
```
```sh
export http_proxy=localhost:8080
export https_proxy=localhost:8080

python http_get.py
```

---
/assets/http-get-1.png
size: contain
---
/assets/http-get-2.png
size: contain
---
/assets/http-get-3.png
size: contain
---
/assets/http-get-4.png
size: contain
---

# S3 Example
```python
import boto3

s3 = boto3.client("s3")
s3.get_object(
  Bucket="micktwomey-scratch-example",
  Key="test/prefix1/ham/spam/foo.txt",
)
```
```sh
export http_proxy=localhost:8080
export https_proxy=localhost:8080

python s3_get_object.py
```

---

# Wut?
```python
...
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/endpoint.py", line 377, in _send
    return self.http_session.send(request)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/httpsession.py", line 491, in send
    raise SSLError(endpoint_url=request.url, error=e)
botocore.exceptions.SSLError: SSL validation failed for https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1006)
```

---

# TLS is doing its job
```sh
http_proxy=localhost:8080 https_proxy=localhost:8080 curl https://fourtheorem.com/
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not establish a secure connection to it. To learn more about this situation and how to fix it, please visit the web page mentioned above.
```


---
/assets/https.png
size: contain
---
/assets/mitm.png
size: contain

What's happening?

1. We tell curl to connect via mitmproxy to www.fourtheorem.com using HTTPS
2. curl connects to mitmproxy and tries to verify the TLS certificate
3. curl decides the certificate in the proxy isn't to be trusted and rejects the connection

curl (and TLS) is doing its job: preventing someone from injecting themselves into the HTTP connection and intercepting traffic.

A man in the middle attack (or MITM) was prevented!

Unfortunately that's what we want to do!


---
Luckily mitmproxy generates TLS certificates for you to use:

# Self signed certs to the rescue!
```sh
$ ls -l ~/.mitmproxy/
total 48
-rw-r--r--  1 mick  staff  1172 Sep  4 19:26 mitmproxy-ca-cert.cer
-rw-r--r--  1 mick  staff  1035 Sep  4 19:26 mitmproxy-ca-cert.p12
-rw-r--r--  1 mick  staff  1172 Sep  4 19:26 mitmproxy-ca-cert.pem
-rw-------  1 mick  staff  2411 Sep  4 19:26 mitmproxy-ca.p12
-rw-------  1 mick  staff  2847 Sep  4 19:26 mitmproxy-ca.pem
-rw-r--r--  1 mick  staff   770 Sep  4 19:26 mitmproxy-dhparam.pem
```

If you can somehow tell your command to trust these it will talk via mitmproxy!


---

# ⚠️ Danger! ⚠️ 
# Here be Dragons! 🐉
	Full guide: https://docs.mitmproxy.org/stable/concepts-certificates/

To work mitmproxy requires clients to trust these certificates

This potentially opens up a massive security hole on your machine depending how this is set up

Recommendation: if possible restrict to one off command line invocations rather than install system wide

Luckily we can override on a per invocation basis in curl and boto3


---
curl offers a simple way to trust a cert: `--cacert`

```sh
$ https_proxy=localhost:8080 \
curl --cacert ~/.mitmproxy/mitmproxy-ca-cert.pem \
-I https://www.fourtheorem.com
HTTP/1.1 200 Connection established

HTTP/1.1 200 OK
Server: openresty
Date: Sun, 04 Sep 2022 20:09:03 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 520810
Connection: keep-alive
...
```


---


/assets/mitm-trusted.png
size: contain

---
```text
* Uses proxy env variable https_proxy == 'localhost:8080'
*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080 (#0)
* allocate connect buffer!
* Establish HTTP proxy tunnel to www.google.ie:443
...
* Proxy replied 200 to CONNECT request
...
* successfully set certificate verify locations:
*  CAfile: /Users/mick/.mitmproxy/mitmproxy-ca-cert.pem
*  CApath: none
* (304) (OUT), TLS handshake, Client hello (1):
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-AES256-GCM-SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=*.google.ie
*  start date: Sep 17 11:58:59 2022 GMT
*  expire date: Sep 19 11:58:59 2023 GMT
*  subjectAltName: host "www.google.ie" matched cert's "*.google.ie"
*  issuer: CN=mitmproxy; O=mitmproxy
*  SSL certificate verify ok.
...
```


---
We can do something similar with boto3:

# AWS_CA_BUNDLE
```sh
https_proxy=localhost:8080 \
AWS_CA_BUNDLE=$HOME/.mitmproxy/mitmproxy-ca-cert.pem \
python examples/s3_get_object.py
```

We tell boto3 to use a different cert bundle (`AWS_CA_BUNDLE`)
---

/assets/mitmproxy-s3-get-1.png
size: contain
---
/assets/mitmproxy-s3-get-2.png
size: contain
---
/assets/mitmproxy-s3-get-3.png
size: contain
---
/assets/mitmproxy-s3-get-4.png
size: contain
---
/assets/mitmproxy-s3-get-5.png
size: contain

---
# What were we doing again?
	1. Got some jobs taking a long time
	2. Guessed it's retries causing this
	3. Want to use events to monitor these but don't have docs
	4. Want to somehow modify responses to simulate retries and see what happens
	5. Can intercept requests using mitmproxy
	6. ??

---

# More than a HTTP debugger
	https://docs.mitmproxy.org/stable/mitmproxytutorial-interceptrequests/
	https://docs.mitmproxy.org/stable/mitmproxytutorial-modifyrequests/

mitmproxy offers the ability to intercept and change HTTP requests

It also offers a full API and the ability to replay requests

---

	1. Hit `i` to create an intercept
	2. `~d s3.eu-west-1.amazonaws.com & ~s`
	   `~d` match on domain, `~s` match on server response
	3. Run the command
	4. In the UI go into the response and hit `e`
	5. Change the response code to `429`
	6. Hit `a` to allow the request to continue
	7. Watch what happens in the command

---
/assets/mitm-intercept-01.png
size: contain
---
/assets/mitm-intercept-02.png
size: contain
---
/assets/mitm-intercept-03.png
size: contain
---
/assets/mitm-intercept-04.png
size: contain
---
/assets/mitm-intercept-05.png
size: contain
---
/assets/mitm-intercept-06.png
size: contain
---
/assets/mitm-intercept-07.png
size: contain
---
/assets/mitm-intercept-08.png
size: contain
---
/assets/mitm-intercept-09.png
size: contain
---
/assets/mitm-intercept-10.png
size: contain
---
/assets/mitm-intercept-11.png
size: contain
---
/assets/mitm-intercept-12.png
size: contain

---

```python
import logging

from mitmproxy import flowfilter
from mitmproxy import http


class RateLimitExceededFilter:
    filter: flowfilter.TFilter

    def __init__(self):
        self.filter = flowfilter.parse("~d s3.eu-west-1.amazonaws.com & ~s")

    def response(self, flow: http.HTTPFlow) -> None:
        if flowfilter.match(self.filter, flow):
            logging.info(
              f"Flow {flow.request} matches filter: setting HTTP 429"
            )
            flow.response.status_code = 429
            flow.response.reason = "Too Many Requests"


addons = [RateLimitExceededFilter()]
```

---

```sh
mitmproxy -s examples/mitm_interception.py
```

---
/assets/mitm-intercept-script-1.png
size: contain
---
/assets/mitm-intercept-script-2.png
size: contain
---
/assets/mitm-intercept-script-3.png
size: contain
---
/assets/mitm-intercept-script-4.png
size: contain
---
/assets/mitm-intercept-script-5.png
size: contain


---

```python
import boto3
from rich import print
import time


def print_event(event_name: str, attempts: int, operation, response, request_dict, **_):
    print(
        event_name,
        operation,
        attempts,
        response[1]["ResponseMetadata"]["HTTPStatusCode"],
        request_dict["context"]["retries"],
    )


s3 = boto3.client("s3")
s3.meta.events.register("needs-retry.s3.ListBuckets", print_event)
s3.list_buckets()
```

Now we have a way to intercept let's start logging out the bits we might be interested in!

---


/assets/retrying-2.png
size: contain
---


/assets/retrying-3.png
size: contain


And here you can see the output

Note the attempt count, it always starts on 1 and retries start on 2.

This is counter to my original intuition, I expected 0.

So we now know to only pay attention to the count when > 1

---

# Will this ever end?
	1. Got some jobs taking a long time
	2. Guessed it's retries causing this
	3. Want to use events to monitor these but don't have docs
	4. Want to somehow modify responses to simulate retries and see what happens
	5. Can intercept requests using mitmproxy
	6. Now know the shape of the data we get in 429 responses
	7. ??

---

```python
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
```

---

/assets/retry-metrics.png
size: contain

Note that we're retrying until the exception is raised, but remember that in production we usually didn't get an error, just slow downs.

Now we can graph these and see how bad things are!

---



/assets/retries.png
size: contain

The graph shows over 250K retry attempts at the peak!

It also shows some kind of oscillation, possibly due to so many connections sleeping at the same time.

Each horizontal tick mark is a minute

With some refinements we can now hone in on where this is happening

---


# Finally!
	1. Got some jobs taking a long time
	2. Guessed it's retries causing this
	3. Want to use events to monitor these but don't have docs
	4. Want to somehow modify responses to simulate retries and see what happens
	5. Can intercept requests using mitmproxy
	6. Now know the shape of the data we get in 429 responses
	7. Can emit metrics and graph them

---

# What We Covered

## AWS API limits

## boto3's event system

## How request retries behave

## mitmproxy

## That nothing is ever simple!

---

# Thank You! 🎉
# 🐘 [mastodon.ie/@micktwomey](https://mastodon.ie/@micktwomey)
# 🧑🏽‍💼 [fourtheorem.com](https://fourtheorem.com/)

# github.com/micktwomey/
# exploring-boto3-events-with-mitmproxy
/assets/qr-slides.png
size: contain

