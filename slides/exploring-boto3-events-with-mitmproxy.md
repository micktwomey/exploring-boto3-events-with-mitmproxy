theme: fourTheorem, 1
slidenumbers: true

# [fit] Exploring Boto3 Events with MitmProxy

## AWS ComSum September 22, 2022

Michael Twomey



@micktwomey / michael.twomey@fourtheorem.com

![](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/images/fourtheorem-background.jpg)

---

[.column]

# About Me

- ☁️ Senior Cloud Architect at fourTheorem
- Started my career in Sun Microsystems working on the Solaris OS
- 🐍 Been coding in Python for over 20 years
- Started kicking the tyres of AWS back when it was just S3, EC2 and SQS

[.column]

# About fourTheorem

![inline](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/images/fourTheorem-Logo-Colour.png)

![inline](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/images/awsbites.png)

- Accelerated Serverless
- AI as a Service
- Platform Modernisation

---

# What I'll be Talking About

- A dash of AWS APIs
- A bit of Python
- Some boto3
- A pinch of HTTP
- A tiny bit of TLS
- A portion of mitmproxy

---

# The Setup

Client code base using Python and the boto3 library to talk to AWS

The core of the system runs a huge amount of computations spread over a large amount of jobs in either Lambdas or Fargate containers [^1]

[^1]: For more details check out the [slides](https://d1.awsstatic.com/aws-summit-london-session-slides/But%20what%20is%20a%20modern%20application%20anyway.pdf) from the AWS Summit London 2022 talk "But what is a modern application anyway?"


---

# The Problem We Were Trying to Solve

During peaks we would occassionally see large slow downs and sometimes errors in some jobs.

We wanted to answer the question:

> "Are we triggering a lot of request retries?"

---

# Request Retries


---

# boto3 Events

Events[^2] are an extension mechanism for boto3

You register a function to be called when an event matching a pattern happens.

Wildcards (`*`) are also allowed for patterns.

```python
s3.meta.events.register("provide-client-params.s3.ListObjects", my_function)
s3.meta.events.register("provide-client-params.s3.*", my_function)
s3.meta.events.register("provide-client-params.*", my_function)
s3.meta.events.register("*", my_function)
```

[^2]: boto3 event docs over at https://boto3.amazonaws.com/v1/documentation/api/latest/guide/events.html

---

```python
import boto3
from rich import print


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

# boto3 Event Args

```python
import boto3
from rich import print

def print_event(event_name, **kwargs):
    print(event_name, kwargs)


s3 = boto3.client("s3")
s3.meta.events.register("*", print_event)

```

- Python can capture keyword arguments (`foo="bar"`) into a variable using `**myvar`.


---

# Example kwargs

![inline fill](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/outputs/basic_event_logging.gif)


---

# Some Observations

- That's a lot of different inputs for different events!
- The list of events isn't explicitly documented
- The args each event can receive isn't explicitly documented

=> It's hard to guess what code you'll need to implement without triggering the behaviour you want

---

# Side track: Extending Libraries in Python

There are a few "classic" approaches to extending code in Python:

1. Inheritence
2. Callbacks
3. Events

---

# Inheritence

[.column]
```python
class MyLibrary:
  def do_something(self, arg1: int, arg2: float):
    ... library does something here ...

class MyModifiedLibrary(MyLibrary):
  def do_something(self, arg1: int, arg2: float):
    ... your stuff happens ...
    # call the original code too:
    super().do_something(arg1, arg2)
```

[.column]
- Works best with libraries written as a bunch of classes
- Can be very clunky and hard to predict how code will interact
- Usually needs explicit hooks for cleanly overriding functionality

---

# Callbacks

[.column]
```python
def add_handler(handler: Callable[[int, float], str]):
    pass

def my_handler(arg1: int, arg2: float) -> str:
    pass

def my_broken_handler(arg1: str, arg2: str) -> str:
    pass

add_handler(my_handler)

# error: Argument 1 to "add_handler"
# has incompatible type "Callable[[str, str], str]";
# expected "Callable[[int, float], str]"
add_handler(my_broken_handler)
```

[.column]
- Generally add_handler keeps a lis of functions to call somewhere
- This approach allows for typing hints to guide the developer
- Generally easy to document

---

# Events

[.column]
```python
def add_handler(event: str, handler: Callable):
    pass

def my_handler(arg1: int, arg2: float):
    pass

def my_other_handler(arg1: str):
    pass

add_handler("x.*", my_handler)
add_handler("y.*", my_other_handler)

# This will probably break
add_handler("y.*", my_handler)
```

[.column]
- Events usually used for generic hooks in libraries
- Ideally should have a consistent set of args for your handlers
- Requires more documentations to guide the programmer

---

# boto3 Uses Events

Generic event hooks much easier to integrate to library, especially when dynamically generated like boto3

Drawback: can be very hard for the developer to know what events exist and how they behave

Solution: Lets watch them play out!

🤔 Now, how do we trigger rate limits?

---

# Triggering a rate limit

There are many ways to trigger problems:

- Hacking the library
- Hacking Python
- Hacking the network
- Triggering the problem for real

I chose to mess with the network

Why? This is close(ish) to what would be seen in real life

---

# HTTP

We can mess with the HTTP responses boto3 gets

In particular:
- For a rate limit I'm betting boto3 looks at the HTTP response code
- I'm also betting it'll be HTTP 429
- I'm also betting the code doesn't care about the payload too much once it's a 429

=> Lets change the response code!

---

[.column]

# From this

```javascript
HTTP/1.1 200 OK
Content-Length: 34202
Content-Type: application/json
...

{
  ...
}
```

[.column]

# To this

```javascript
HTTP/1.1 429 Rate limit exceeded
Content-Length: 34202
Content-Type: application/json;
...

{
  ...
}
```

---

# How do we achieve this?

One way to mess with HTTP is using a HTTP proxy

One tool which implements this is mitmproxy

---

# mitmproxy

https://mitmproxy.org

> mitmproxy is a free and open source interactive HTTPS proxy.

What?

Let's you mess with the HTTP requests and responses from programs

Bit like Chrome Dev Tools for all your HTTP speaking commands

![fit right](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/images/mitmproxy.png)

---

# Basic usage

[.column]
1. Run `mitmproxy` (or `mitmweb` for a fancier web interface)
2. Set the HTTP proxy settings to mitmproxy's (defaults to http://localhost:8080)
3. Run your program
4. Watch in mitmproxy

Easy right?

[.column]
```sh
export http_proxy=localhost:8080
export https_proxy=localhost:8080

python my_app.py
```

---

![fit](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/outputs/tmux-2022-09-04--2105.gif)

---

# curl

```sh
❯ https_proxy=localhost:8080 curl -I https://www.fourtheorem.com
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```

Not so easy after all!

---

# TLS

What's happening?

1. We tell curl to connect via mitmproxy to www.fourtheorem.com using HTTPS
2. curl connects to mitmproxy and tries to verify the TLS certificate
3. curl decides the certificate in the proxy isn't to be trusted and rejects the connection

---

# MITM

curl (and TLS) is doing its job: preventing someone from injecting themselves into the HTTP connection and intercepting traffic.

A man in the middle attack (or MITM) was prevented!

Unfortunately that's what we want to do!

---

# mitmproxy has an answer

Luckily mitmproxy makes TLS certificates for you to use:

```sh
❯ ls -l ~/.mitmproxy/
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

# Danger! ⚠️ Here be Dragons! 🐉

To work mitmproxy requires clients to trust these certificates

This potentially opens up a massive security hole on your machine depending how this is set up

Recommendation: if possible restrict to one off command line invocations rather than install system wide

Luckily we can override on a per invocation basis in curl and boto3

Full guide: https://docs.mitmproxy.org/stable/concepts-certificates/

---

# Overriding the cert bundle

curl offers a simple way to trust a cert: `--cacert`

```sh
❯ https_proxy=localhost:8080 curl --cacert ~/.mitmproxy/mitmproxy-ca-cert.pem -I https://www.fourtheorem.com
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

![fit](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/outputs/tmux-2022-09-04--2106.gif)

---

# boto3

We can do something similar with boto3:

```sh
❯ https_proxy=localhost:8080 \
  AWS_CA_BUNDLE=$HOME/.mitmproxy/mitmproxy-ca-cert.pem \
  python examples/print_events.py

S3:
provide-client-params.s3.ListBuckets
before-parameter-build.s3.ListBuckets
before-call.s3.ListBuckets
request-created.s3.ListBuckets
...
```

We tell boto3 to use a different cert bundle (`AWS_CA_BUNDLE`)

---

![fit](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/outputs/tmux-2022-09-04--2130.gif)

---

# What Were We Trying to Do Again?

We can now:
1. Run some requests from boto3 to AWS
2. Intercept and inspect these requests in mitmproxy

How does this help us?

---

# More than a HTTP debugger

mitmproxy offers the ability to intercept and change HTTP requests

(It also offers a full API and the ability to replay requests)

https://docs.mitmproxy.org/stable/mitmproxytutorial-interceptrequests/

https://docs.mitmproxy.org/stable/mitmproxytutorial-modifyrequests/

---

# Intercepting

1. Hit `i` to create an intercept
2. `~d s3.eu-west-1.amazonaws.com & ~s`
3. Run the command
4. In the UI go into the response and hit `e`
5. Change the response code to 429
6. Hit `a` to allow the request to continue
7. Watch what happens in the command

---

Modified code to focus on retry mechanism for brevity

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

---

![fit](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/outputs/tmux-2022-09-04--2214.gif)

---

```python
❯ https_proxy=localhost:8080 \
  AWS_CA_BUNDLE=$HOME/.mitmproxy/mitmproxy-ca-cert.pem \
  python examples/intercepting.py

needs-retry.s3.ListBuckets OperationModel(name=ListBuckets) 1 429
{'attempt': 1, 'invocation-id': '...'}
needs-retry.s3.ListBuckets OperationModel(name=ListBuckets) 2 429
{'attempt': 2, 'invocation-id': '...', 'max': 5, 'ttl': '20220904T211601Z'}
needs-retry.s3.ListBuckets OperationModel(name=ListBuckets) 3 200
{'attempt': 3, 'invocation-id': '...', 'max': 5, 'ttl': '20220904T211623Z'}
```

Observations:
1. The retry counter starts at 1
2. It increments every time there's a retried call
3. Can test for `attempt > 1`

---

Finally! Can emit metrics!

```python
import boto3
from rich import print


def increment_metric(name):
    print(f"{name}|increment|count=1")


def handle_retry(event_name: str, attempts: int, **_):
    if attempts > 1:
        increment_metric(event_name)


s3 = boto3.client("s3")
s3.meta.events.register("needs-retry.s3.*", handle_retry)
s3.list_buckets()
print("All done!")
```

---

![fit](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/outputs/tmux-2022-09-04--2239.gif)

---

# So What Was the Point of All That?

![left fit](/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/images/retries.png)

```
fields @timestamp, event_name
| filter ispresent(event_name)
| filter event_name	= 'needs-retry.s3.PutObject'
| filter attempts > 1
| sort by @timestamp asc
| stats count() by bin(1m)
```

The graph shows over 250K retry attempts at the peak!
