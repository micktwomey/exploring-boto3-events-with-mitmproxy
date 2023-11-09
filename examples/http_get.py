import httpx
from rich import print

response = httpx.get("http://httpbin.org/get")
print(response)
print(response.headers)
print(response.json())
