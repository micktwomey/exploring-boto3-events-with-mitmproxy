theme: Huerta, 1
slidenumbers: true

## Exploring Boto3 Events with MitmProxy
### Michael Twomey @ fourTheorem

---

# About Me

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
