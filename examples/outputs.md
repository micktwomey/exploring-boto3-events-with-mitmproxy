# Simulating 429

```
https_proxy=localhost:8080 AWS_CA_BUNDLE=$HOME/.mitmproxy/mitmproxy-ca-cert.pem  python examples/s3_get_object.py
2023-11-07 12:05:04 [info     ] starting
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from creating-client-class.iot-data to creating-client-class.iot-data-plane
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from before-call.apigateway to before-call.api-gateway
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from request-created.machinelearning.Predict to request-created.machine-learning.Predict
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from before-parameter-build.autoscaling.CreateLaunchConfiguration to before-parameter-build.auto-scaling.CreateLaunchConfiguration
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from before-parameter-build.route53 to before-parameter-build.route-53
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from request-created.cloudsearchdomain.Search to request-created.cloudsearch-domain.Search
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from docs.*.autoscaling.CreateLaunchConfiguration.complete-section to docs.*.auto-scaling.CreateLaunchConfiguration.complete-section
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from before-parameter-build.logs.CreateExportTask to before-parameter-build.cloudwatch-logs.CreateExportTask
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from docs.*.logs.CreateExportTask.complete-section to docs.*.cloudwatch-logs.CreateExportTask.complete-section
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from before-parameter-build.cloudsearchdomain.Search to before-parameter-build.cloudsearch-domain.Search
2023-11-07 12:05:04 DEBUG botocore.hooks Changing event name from docs.*.cloudsearchdomain.Search.complete-section to docs.*.cloudsearch-domain.Search.complete-section
2023-11-07 12:05:04 DEBUG botocore.utils IMDS ENDPOINT: http://169.254.169.254/
2023-11-07 12:05:04 DEBUG botocore.credentials Looking for credentials via: env
2023-11-07 12:05:04 INFO botocore.credentials Found credentials in environment variables.
2023-11-07 12:05:04 DEBUG botocore.loaders Loading JSON file: /Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/data/endpoints.json
2023-11-07 12:05:04 DEBUG botocore.loaders Loading JSON file: /Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/data/sdk-default-configuration.json
2023-11-07 12:05:04 DEBUG botocore.hooks Event choose-service-name: calling handler <function handle_service_name_alias at 0x110d3dee0>
2023-11-07 12:05:04 DEBUG botocore.loaders Loading JSON file: /Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/data/s3/2006-03-01/service-2.json
2023-11-07 12:05:04 DEBUG botocore.loaders Loading JSON file: /Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/data/s3/2006-03-01/endpoint-rule-set-1.json.gz
2023-11-07 12:05:04 DEBUG botocore.loaders Loading JSON file: /Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/data/partitions.json
2023-11-07 12:05:04 DEBUG botocore.hooks Event creating-client-class.s3: calling handler <function add_generate_presigned_post at 0x110c579c0>
2023-11-07 12:05:04 DEBUG botocore.hooks Event creating-client-class.s3: calling handler <function lazy_call.<locals>._handler at 0x111b5ba60>
2023-11-07 12:05:04 DEBUG botocore.hooks Event creating-client-class.s3: calling handler <function add_generate_presigned_url at 0x110c57740>
2023-11-07 12:05:04 DEBUG botocore.configprovider Looking for endpoint for s3 via: environment_service
2023-11-07 12:05:04 DEBUG botocore.configprovider Looking for endpoint for s3 via: environment_global
2023-11-07 12:05:04 DEBUG botocore.configprovider Looking for endpoint for s3 via: config_service
2023-11-07 12:05:04 DEBUG botocore.configprovider Looking for endpoint for s3 via: config_global
2023-11-07 12:05:04 DEBUG botocore.configprovider No configured endpoint found.
2023-11-07 12:05:04 DEBUG botocore.endpoint Setting s3 timeout as (60, 60)
2023-11-07 12:05:04 DEBUG botocore.loaders Loading JSON file: /Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/data/_retry.json
2023-11-07 12:05:04 DEBUG botocore.client Registering retry handlers for service: s3
2023-11-07 12:05:04 DEBUG botocore.utils Registering S3 region redirector handler
2023-11-07 12:05:04 [info     ] s3.get                         bucket=micktwomey-scratch-example key=test/prefix1/ham/spam/foo.txt
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
x-amz-security-token:IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu

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
2023-11-07 12:05:04 DEBUG botocore.endpoint Sending http request: <AWSPreparedRequest stream_output=True, method=GET, url=https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt, headers={'User-Agent': b'Boto3/1.28.79 md/Botocore#1.31.79 ua/2.0 os/macos#23.0.0 md/arch#x86_64 lang/python#3.11.5 md/pyimpl#CPython cfg/retry-mode#legacy Botocore/1.31.79', 'X-Amz-Date': b'20231107T120504Z', 'X-Amz-Security-Token': b'IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu', 'X-Amz-Content-SHA256': b'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Authorization': b'AWS4-HMAC-SHA256 Credential=ASIAVYOFBVCIGIENLWHC/20231107/eu-west-1/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token, Signature=30dfcec555fb14f449a78972ecd2063c76b5c93a70f5ef5a6a16e52aed405b79', 'amz-sdk-invocation-id': b'ccde3a33-bb84-4e1a-8d96-8dca5603675e', 'amz-sdk-request': b'attempt=1'}>
2023-11-07 12:05:04 DEBUG urllib3.connectionpool Starting new HTTPS connection (1): micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443
2023-11-07 12:05:34 DEBUG urllib3.connectionpool https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 "GET /test/prefix1/ham/spam/foo.txt HTTP/1.1" 429 6
2023-11-07 12:05:34 DEBUG botocore.parsers Response headers: {'x-amz-id-2': 'f9LhDR49/reXInKFyrMoVCRDn7CAoYrbt1/rr+dVa05nqPd0p758D+UqmoALBFGHknjW8cXBlvc=', 'x-amz-request-id': '69C7G5TXHE26TC2Z', 'Date': 'Tue, 07 Nov 2023 12:05:06 GMT', 'Last-Modified': 'Fri, 20 Oct 2023 17:06:43 GMT', 'ETag': '"b1946ac92492d2347c6235b4d2611184"', 'x-amz-server-side-encryption': 'AES256', 'Accept-Ranges': 'bytes', 'Content-Type': 'text/plain', 'Server': 'AmazonS3', 'Content-Length': '6'}
2023-11-07 12:05:34 DEBUG botocore.parsers Response body:
b'hello\n'
2023-11-07 12:05:34 DEBUG botocore.parsers Exception caught when parsing error response body:
Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 505, in _parse_xml_string_to_dom
    parser.feed(xml_string)
xml.etree.ElementTree.ParseError: syntax error: line 1, column 0

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1054, in _do_error_parse
    return self._parse_error_from_body(response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1078, in _parse_error_from_body
    root = self._parse_xml_string_to_dom(xml_contents)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 508, in _parse_xml_string_to_dom
    raise ResponseParserError(
botocore.parsers.ResponseParserError: Unable to parse response (syntax error: line 1, column 0), invalid XML received. Further retries may succeed:
b'hello\n'
2023-11-07 12:05:34 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <botocore.retryhandler.RetryHandler object at 0x11432fe10>
2023-11-07 12:05:34 DEBUG botocore.retryhandler retry needed: retryable HTTP status code received: 429
2023-11-07 12:05:34 DEBUG botocore.retryhandler Retry needed, action of: 0.9999734397833178
2023-11-07 12:05:34 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <bound method S3RegionRedirectorv2.redirect_from_error of <botocore.utils.S3RegionRedirectorv2 object at 0x114319fd0>>
2023-11-07 12:05:34 DEBUG botocore.endpoint Response received to retry, sleeping for 0.9999734397833178 seconds
2023-11-07 12:05:35 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <bound method RequestSigner.handler of <botocore.signers.RequestSigner object at 0x114319510>>
2023-11-07 12:05:35 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <bound method ClientCreator._default_s3_presign_to_sigv2 of <botocore.client.ClientCreator object at 0x110e138d0>>
2023-11-07 12:05:35 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <function set_operation_specific_signer at 0x110d3f560>
2023-11-07 12:05:35 DEBUG botocore.hooks Event before-sign.s3.GetObject: calling handler <function remove_arn_from_signing_path at 0x110d5db20>
2023-11-07 12:05:35 DEBUG botocore.auth Calculating signature using v4 auth.
2023-11-07 12:05:35 DEBUG botocore.auth CanonicalRequest:
GET
/test/prefix1/ham/spam/foo.txt

host:micktwomey-scratch-example.s3.eu-west-1.amazonaws.com
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20231107T120535Z
x-amz-security-token:IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
2023-11-07 12:05:35 DEBUG botocore.auth StringToSign:
AWS4-HMAC-SHA256
20231107T120535Z
20231107/eu-west-1/s3/aws4_request
dbd700ffa58cd355aa2d338fe6796727d48c41790ef6c98606afbe1ab3b2b43e
2023-11-07 12:05:35 DEBUG botocore.auth Signature:
69ab50a313c3a60021ff552d5e334f69da236884b5a0a05a4a15945aa43407e4
2023-11-07 12:05:35 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <function add_retry_headers at 0x110d5d940>
2023-11-07 12:05:35 DEBUG botocore.endpoint Sending http request: <AWSPreparedRequest stream_output=True, method=GET, url=https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt, headers={'User-Agent': b'Boto3/1.28.79 md/Botocore#1.31.79 ua/2.0 os/macos#23.0.0 md/arch#x86_64 lang/python#3.11.5 md/pyimpl#CPython cfg/retry-mode#legacy Botocore/1.31.79', 'X-Amz-Date': b'20231107T120535Z', 'X-Amz-Security-Token': b'IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu', 'X-Amz-Content-SHA256': b'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Authorization': b'AWS4-HMAC-SHA256 Credential=ASIAVYOFBVCIGIENLWHC/20231107/eu-west-1/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token, Signature=69ab50a313c3a60021ff552d5e334f69da236884b5a0a05a4a15945aa43407e4', 'amz-sdk-invocation-id': b'ccde3a33-bb84-4e1a-8d96-8dca5603675e', 'amz-sdk-request': b'ttl=20231107T120606Z; attempt=2; max=5'}>
2023-11-07 12:05:49 DEBUG urllib3.connectionpool https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 "GET /test/prefix1/ham/spam/foo.txt HTTP/1.1" 429 6
2023-11-07 12:05:49 DEBUG botocore.parsers Response headers: {'x-amz-id-2': 'OK5LCZ7oGBWQb1FF6Cl8k4q85eNDPu2fjJxOmGrecN6cddnZ0AVXvT6rZzcvUH9T3Yv53tswl1Voqjjm3EI5yQ==', 'x-amz-request-id': '8BBWTT8RJF93ZAHZ', 'Date': 'Tue, 07 Nov 2023 12:05:36 GMT', 'Last-Modified': 'Fri, 20 Oct 2023 17:06:43 GMT', 'ETag': '"b1946ac92492d2347c6235b4d2611184"', 'x-amz-server-side-encryption': 'AES256', 'Accept-Ranges': 'bytes', 'Content-Type': 'text/plain', 'Server': 'AmazonS3', 'Content-Length': '6'}
2023-11-07 12:05:49 DEBUG botocore.parsers Response body:
b'hello\n'
2023-11-07 12:05:49 DEBUG botocore.parsers Exception caught when parsing error response body:
Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 505, in _parse_xml_string_to_dom
    parser.feed(xml_string)
xml.etree.ElementTree.ParseError: syntax error: line 1, column 0

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1054, in _do_error_parse
    return self._parse_error_from_body(response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1078, in _parse_error_from_body
    root = self._parse_xml_string_to_dom(xml_contents)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 508, in _parse_xml_string_to_dom
    raise ResponseParserError(
botocore.parsers.ResponseParserError: Unable to parse response (syntax error: line 1, column 0), invalid XML received. Further retries may succeed:
b'hello\n'
2023-11-07 12:05:49 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <botocore.retryhandler.RetryHandler object at 0x11432fe10>
2023-11-07 12:05:49 DEBUG botocore.retryhandler retry needed: retryable HTTP status code received: 429
2023-11-07 12:05:49 DEBUG botocore.retryhandler Retry needed, action of: 1.1200142325626847
2023-11-07 12:05:49 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <bound method S3RegionRedirectorv2.redirect_from_error of <botocore.utils.S3RegionRedirectorv2 object at 0x114319fd0>>
2023-11-07 12:05:49 DEBUG botocore.endpoint Response received to retry, sleeping for 1.1200142325626847 seconds
2023-11-07 12:05:50 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <bound method RequestSigner.handler of <botocore.signers.RequestSigner object at 0x114319510>>
2023-11-07 12:05:50 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <bound method ClientCreator._default_s3_presign_to_sigv2 of <botocore.client.ClientCreator object at 0x110e138d0>>
2023-11-07 12:05:50 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <function set_operation_specific_signer at 0x110d3f560>
2023-11-07 12:05:50 DEBUG botocore.hooks Event before-sign.s3.GetObject: calling handler <function remove_arn_from_signing_path at 0x110d5db20>
2023-11-07 12:05:50 DEBUG botocore.auth Calculating signature using v4 auth.
2023-11-07 12:05:50 DEBUG botocore.auth CanonicalRequest:
GET
/test/prefix1/ham/spam/foo.txt

host:micktwomey-scratch-example.s3.eu-west-1.amazonaws.com
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20231107T120550Z
x-amz-security-token:IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
2023-11-07 12:05:50 DEBUG botocore.auth StringToSign:
AWS4-HMAC-SHA256
20231107T120550Z
20231107/eu-west-1/s3/aws4_request
137d0d6dd942a885809c1e8a15ba53c507777ac1fadd3944e0a748af8e8e9702
2023-11-07 12:05:50 DEBUG botocore.auth Signature:
60b4888378682d022bf776158a36d7c3b7c97cf0489e258025ea2ef4d4583ef7
2023-11-07 12:05:50 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <function add_retry_headers at 0x110d5d940>
2023-11-07 12:05:50 DEBUG botocore.endpoint Sending http request: <AWSPreparedRequest stream_output=True, method=GET, url=https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt, headers={'User-Agent': b'Boto3/1.28.79 md/Botocore#1.31.79 ua/2.0 os/macos#23.0.0 md/arch#x86_64 lang/python#3.11.5 md/pyimpl#CPython cfg/retry-mode#legacy Botocore/1.31.79', 'X-Amz-Date': b'20231107T120550Z', 'X-Amz-Security-Token': b'IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu', 'X-Amz-Content-SHA256': b'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Authorization': b'AWS4-HMAC-SHA256 Credential=ASIAVYOFBVCIGIENLWHC/20231107/eu-west-1/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token, Signature=60b4888378682d022bf776158a36d7c3b7c97cf0489e258025ea2ef4d4583ef7', 'amz-sdk-invocation-id': b'ccde3a33-bb84-4e1a-8d96-8dca5603675e', 'amz-sdk-request': b'ttl=20231107T120636Z; attempt=3; max=5'}>
2023-11-07 12:06:01 DEBUG urllib3.connectionpool https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 "GET /test/prefix1/ham/spam/foo.txt HTTP/1.1" 429 6
2023-11-07 12:06:01 DEBUG botocore.parsers Response headers: {'x-amz-id-2': 'aM2zHpffW5wBRFbDPpea3gj7N9Ngez+pD0mDHWaFiGcLBPL3TOjxHFhVJQkJOwMAcNs0pMnxiBmaeGyxhRNgyw==', 'x-amz-request-id': 'J0VPB10DBKG7VYST', 'Date': 'Tue, 07 Nov 2023 12:05:52 GMT', 'Last-Modified': 'Fri, 20 Oct 2023 17:06:43 GMT', 'ETag': '"b1946ac92492d2347c6235b4d2611184"', 'x-amz-server-side-encryption': 'AES256', 'Accept-Ranges': 'bytes', 'Content-Type': 'text/plain', 'Server': 'AmazonS3', 'Content-Length': '6'}
2023-11-07 12:06:01 DEBUG botocore.parsers Response body:
b'hello\n'
2023-11-07 12:06:01 DEBUG botocore.parsers Exception caught when parsing error response body:
Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 505, in _parse_xml_string_to_dom
    parser.feed(xml_string)
xml.etree.ElementTree.ParseError: syntax error: line 1, column 0

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1054, in _do_error_parse
    return self._parse_error_from_body(response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1078, in _parse_error_from_body
    root = self._parse_xml_string_to_dom(xml_contents)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 508, in _parse_xml_string_to_dom
    raise ResponseParserError(
botocore.parsers.ResponseParserError: Unable to parse response (syntax error: line 1, column 0), invalid XML received. Further retries may succeed:
b'hello\n'
2023-11-07 12:06:01 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <botocore.retryhandler.RetryHandler object at 0x11432fe10>
2023-11-07 12:06:01 DEBUG botocore.retryhandler retry needed: retryable HTTP status code received: 429
2023-11-07 12:06:01 DEBUG botocore.retryhandler Retry needed, action of: 2.9186937170858336
2023-11-07 12:06:01 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <bound method S3RegionRedirectorv2.redirect_from_error of <botocore.utils.S3RegionRedirectorv2 object at 0x114319fd0>>
2023-11-07 12:06:01 DEBUG botocore.endpoint Response received to retry, sleeping for 2.9186937170858336 seconds
2023-11-07 12:06:04 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <bound method RequestSigner.handler of <botocore.signers.RequestSigner object at 0x114319510>>
2023-11-07 12:06:04 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <bound method ClientCreator._default_s3_presign_to_sigv2 of <botocore.client.ClientCreator object at 0x110e138d0>>
2023-11-07 12:06:04 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <function set_operation_specific_signer at 0x110d3f560>
2023-11-07 12:06:04 DEBUG botocore.hooks Event before-sign.s3.GetObject: calling handler <function remove_arn_from_signing_path at 0x110d5db20>
2023-11-07 12:06:04 DEBUG botocore.auth Calculating signature using v4 auth.
2023-11-07 12:06:04 DEBUG botocore.auth CanonicalRequest:
GET
/test/prefix1/ham/spam/foo.txt

host:micktwomey-scratch-example.s3.eu-west-1.amazonaws.com
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20231107T120604Z
x-amz-security-token:IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
2023-11-07 12:06:04 DEBUG botocore.auth StringToSign:
AWS4-HMAC-SHA256
20231107T120604Z
20231107/eu-west-1/s3/aws4_request
f503e7b6568905708da4481a0acef36276dca68a927ac0178543828d201f96fd
2023-11-07 12:06:04 DEBUG botocore.auth Signature:
cbd3737a7c99cd0a420ae9bc86f5891a97ff284758c219c6e11631ddf7492601
2023-11-07 12:06:04 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <function add_retry_headers at 0x110d5d940>
2023-11-07 12:06:04 DEBUG botocore.endpoint Sending http request: <AWSPreparedRequest stream_output=True, method=GET, url=https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt, headers={'User-Agent': b'Boto3/1.28.79 md/Botocore#1.31.79 ua/2.0 os/macos#23.0.0 md/arch#x86_64 lang/python#3.11.5 md/pyimpl#CPython cfg/retry-mode#legacy Botocore/1.31.79', 'X-Amz-Date': b'20231107T120604Z', 'X-Amz-Security-Token': b'IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu', 'X-Amz-Content-SHA256': b'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Authorization': b'AWS4-HMAC-SHA256 Credential=ASIAVYOFBVCIGIENLWHC/20231107/eu-west-1/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token, Signature=cbd3737a7c99cd0a420ae9bc86f5891a97ff284758c219c6e11631ddf7492601', 'amz-sdk-invocation-id': b'ccde3a33-bb84-4e1a-8d96-8dca5603675e', 'amz-sdk-request': b'ttl=20231107T120652Z; attempt=4; max=5'}>
2023-11-07 12:06:22 DEBUG urllib3.connectionpool https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 "GET /test/prefix1/ham/spam/foo.txt HTTP/1.1" 429 6
2023-11-07 12:06:22 DEBUG botocore.parsers Response headers: {'x-amz-id-2': 'HeOIJ7haK10wQofOtuTuRVxUNcasEWqZCGzpDl9bWaWu/A93ovzj9J3Fdj/5jsm5FwoKinvsEOIoMR+I/SwUrw==', 'x-amz-request-id': '4CQE6GE0BC1PETVH', 'Date': 'Tue, 07 Nov 2023 12:06:05 GMT', 'Last-Modified': 'Fri, 20 Oct 2023 17:06:43 GMT', 'ETag': '"b1946ac92492d2347c6235b4d2611184"', 'x-amz-server-side-encryption': 'AES256', 'Accept-Ranges': 'bytes', 'Content-Type': 'text/plain', 'Server': 'AmazonS3', 'Content-Length': '6'}
2023-11-07 12:06:22 DEBUG botocore.parsers Response body:
b'hello\n'
2023-11-07 12:06:22 DEBUG botocore.parsers Exception caught when parsing error response body:
Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 505, in _parse_xml_string_to_dom
    parser.feed(xml_string)
xml.etree.ElementTree.ParseError: syntax error: line 1, column 0

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1054, in _do_error_parse
    return self._parse_error_from_body(response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1078, in _parse_error_from_body
    root = self._parse_xml_string_to_dom(xml_contents)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 508, in _parse_xml_string_to_dom
    raise ResponseParserError(
botocore.parsers.ResponseParserError: Unable to parse response (syntax error: line 1, column 0), invalid XML received. Further retries may succeed:
b'hello\n'
2023-11-07 12:06:22 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <botocore.retryhandler.RetryHandler object at 0x11432fe10>
2023-11-07 12:06:22 DEBUG botocore.retryhandler retry needed: retryable HTTP status code received: 429
2023-11-07 12:06:22 DEBUG botocore.retryhandler Retry needed, action of: 1.8296065423301888
2023-11-07 12:06:22 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <bound method S3RegionRedirectorv2.redirect_from_error of <botocore.utils.S3RegionRedirectorv2 object at 0x114319fd0>>
2023-11-07 12:06:22 DEBUG botocore.endpoint Response received to retry, sleeping for 1.8296065423301888 seconds
2023-11-07 12:06:24 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <bound method RequestSigner.handler of <botocore.signers.RequestSigner object at 0x114319510>>
2023-11-07 12:06:24 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <bound method ClientCreator._default_s3_presign_to_sigv2 of <botocore.client.ClientCreator object at 0x110e138d0>>
2023-11-07 12:06:24 DEBUG botocore.hooks Event choose-signer.s3.GetObject: calling handler <function set_operation_specific_signer at 0x110d3f560>
2023-11-07 12:06:24 DEBUG botocore.hooks Event before-sign.s3.GetObject: calling handler <function remove_arn_from_signing_path at 0x110d5db20>
2023-11-07 12:06:24 DEBUG botocore.auth Calculating signature using v4 auth.
2023-11-07 12:06:24 DEBUG botocore.auth CanonicalRequest:
GET
/test/prefix1/ham/spam/foo.txt

host:micktwomey-scratch-example.s3.eu-west-1.amazonaws.com
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20231107T120624Z
x-amz-security-token:IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
2023-11-07 12:06:24 DEBUG botocore.auth StringToSign:
AWS4-HMAC-SHA256
20231107T120624Z
20231107/eu-west-1/s3/aws4_request
dfbd919bf6eccfed526cef46be2fec19285d9ec1c4327329d7b655fe168dc9e0
2023-11-07 12:06:24 DEBUG botocore.auth Signature:
e0cd0918a5f77aeaa5589de038476976b249490dc016ee6da2c668dd4432f5f5
2023-11-07 12:06:24 DEBUG botocore.hooks Event request-created.s3.GetObject: calling handler <function add_retry_headers at 0x110d5d940>
2023-11-07 12:06:24 DEBUG botocore.endpoint Sending http request: <AWSPreparedRequest stream_output=True, method=GET, url=https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com/test/prefix1/ham/spam/foo.txt, headers={'User-Agent': b'Boto3/1.28.79 md/Botocore#1.31.79 ua/2.0 os/macos#23.0.0 md/arch#x86_64 lang/python#3.11.5 md/pyimpl#CPython cfg/retry-mode#legacy Botocore/1.31.79', 'X-Amz-Date': b'20231107T120624Z', 'X-Amz-Security-Token': b'IQoJb3JpZ2luX2VjEGwaCWV1LXdlc3QtMSJHMEUCIQDRz3vZ3o579tjSRxYrhZYvwZCZJeGnqr6/c0Pd8a2DHwIgWa1N6C/6oEhcFmiaYoOoYehnD0yBQNsHpnBxr2PeheQqhgMIpf//////////ARAAGgwzOTYwODcxMDk3NzYiDPZ8CdDRfD2w4QIFzyraAooo+hwQYW9/9qbfdaro7LwiQwQROsWicZt5YlQKbpkEMwkuSqC2X+emXxtiGKLIoY9f7Gn2Bi+ykdHj7pZzPhAwPdTQ/iV85ocFmx/dtDVyV0RhxaRwD+J5NLJqwrQQsQE7icxOMhWOC4rgssUoX4U4aekivzYdVnF1ycgSpjbJJ2Xnqeh6kAN0/dWtvZEmESc5p+1bDECcenmMH3Euifd66edtMw174MbqL+AK0v5oG4iAva4InKnHFsEntQZN3dGP7A4qDbYcptUm9jARlDPmnfLBUHzWRBge/4aAE1zSj2FGiPhdC3Zkn+zNp3IvbXt3lDh71QH7Evh0BK6AK7Hym3vNI/hf9lhOXQE3qlgrL2ebPg6WdIDOzSZHks2ZOafPgPxQ6AlSRavniplCoqMww18rhRERZJtKVSUxDoU2xsF3Iqk4RyKu853M2Q8u3AlOjIYd5DRiQa4wosmoqgY6pgE4lwzprZHYpAYGF2PT+8kWxrTkAx+6YETJjz0GMgt31PtpQV29DDV3r68+MUhwkcXb+ykJBZyV+BpP6aFos/FNQln4OkvHOHvy2GI+pUc32OlFvJbOmXlB3wYT+65fJVLNET8FjkolE8rMoIJNg+vBzqq0sLRWzAa0jcQRhRC2DPD46TsclkPqebtB3rtRXfi4M/HxHtgSolXQEd+RN9IcU2F8DSxu', 'X-Amz-Content-SHA256': b'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Authorization': b'AWS4-HMAC-SHA256 Credential=ASIAVYOFBVCIGIENLWHC/20231107/eu-west-1/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token, Signature=e0cd0918a5f77aeaa5589de038476976b249490dc016ee6da2c668dd4432f5f5', 'amz-sdk-invocation-id': b'ccde3a33-bb84-4e1a-8d96-8dca5603675e', 'amz-sdk-request': b'ttl=20231107T120705Z; attempt=5; max=5'}>
2023-11-07 12:06:33 DEBUG urllib3.connectionpool https://micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 "GET /test/prefix1/ham/spam/foo.txt HTTP/1.1" 429 6
2023-11-07 12:06:33 DEBUG botocore.parsers Response headers: {'x-amz-id-2': '7s63IFf61b6jX+2D3o+JFf2o9Chs7Aqd9B8EpyDQmoSPQfAHWE3K/MW+NPJ7j089IftMbMBN3ogajMWXNowtsw==', 'x-amz-request-id': 'S15EHH4JKXZ0W5FW', 'Date': 'Tue, 07 Nov 2023 12:06:25 GMT', 'Last-Modified': 'Fri, 20 Oct 2023 17:06:43 GMT', 'ETag': '"b1946ac92492d2347c6235b4d2611184"', 'x-amz-server-side-encryption': 'AES256', 'Accept-Ranges': 'bytes', 'Content-Type': 'text/plain', 'Server': 'AmazonS3', 'Content-Length': '6'}
2023-11-07 12:06:33 DEBUG botocore.parsers Response body:
b'hello\n'
2023-11-07 12:06:33 DEBUG botocore.parsers Exception caught when parsing error response body:
Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 505, in _parse_xml_string_to_dom
    parser.feed(xml_string)
xml.etree.ElementTree.ParseError: syntax error: line 1, column 0

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1054, in _do_error_parse
    return self._parse_error_from_body(response)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 1078, in _parse_error_from_body
    root = self._parse_xml_string_to_dom(xml_contents)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/parsers.py", line 508, in _parse_xml_string_to_dom
    raise ResponseParserError(
botocore.parsers.ResponseParserError: Unable to parse response (syntax error: line 1, column 0), invalid XML received. Further retries may succeed:
b'hello\n'
2023-11-07 12:06:33 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <botocore.retryhandler.RetryHandler object at 0x11432fe10>
2023-11-07 12:06:33 DEBUG botocore.retryhandler retry needed: retryable HTTP status code received: 429
2023-11-07 12:06:33 DEBUG botocore.retryhandler Reached the maximum number of retry attempts: 5
2023-11-07 12:06:33 DEBUG botocore.retryhandler No retry needed.
2023-11-07 12:06:33 DEBUG botocore.hooks Event needs-retry.s3.GetObject: calling handler <bound method S3RegionRedirectorv2.redirect_from_error of <botocore.utils.S3RegionRedirectorv2 object at 0x114319fd0>>
Traceback (most recent call last):
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/examples/s3_get_object.py", line 12, in <module>
    response = s3.get_object(Bucket=bucket, Key=key)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/client.py", line 535, in _api_call
    return self._make_api_call(operation_name, kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/Users/mick/src/github.com/micktwomey/exploring-boto3-events-with-mitmproxy/.venv/lib/python3.11/site-packages/botocore/client.py", line 980, in _make_api_call
    raise error_class(parsed_response, operation_name)
botocore.exceptions.ClientError: An error occurred (429) when calling the GetObject operation (reached max retries: 4): Too Many Requests
```

Corresponding mitmproxy:

```
Flows
  12:04:31 HTTPS GET  …ratch-example.s3.eu-west-1.amazonaws.com /test/prefix1/ham/spam/foo.txt  200  text/plain  6b  61ms
  12:05:05 HTTPS GET  …ratch-example.s3.eu-west-1.amazonaws.com /test/prefix1/ham/spam/foo.txt  429  text/plain  6b  46ms
  12:05:35 HTTPS GET  …ratch-example.s3.eu-west-1.amazonaws.com /test/prefix1/ham/spam/foo.txt  429  text/plain  6b 118ms
  12:05:50 HTTPS GET  …ratch-example.s3.eu-west-1.amazonaws.com /test/prefix1/ham/spam/foo.txt  429  text/plain  6b 131ms
  12:06:04 HTTPS GET  …ratch-example.s3.eu-west-1.amazonaws.com /test/prefix1/ham/spam/foo.txt  429  text/plain  6b 101ms
>>12:06:24 HTTPS GET  …ratch-example.s3.eu-west-1.amazonaws.com /test/prefix1/ham/spam/foo.txt  429  text/plain  6b 105ms
```

```
Events
info: [12:03:13.994] HTTP(S) proxy listening at *:8080.
info: [12:04:25.705][[::1]:61501] client connect
info: [12:04:25.783][[::1]:61501] server connect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (52.218.98.96:443)
info: [12:04:31.631][[::1]:61501] client disconnect
info: [12:04:31.632][[::1]:61501] server disconnect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (52.218.98.96:443)
info: [12:05:04.975][[::1]:61529] client connect
info: [12:05:05.014][[::1]:61529] server connect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (52.218.31.16:443)
info: [12:05:11.114][[::1]:61529] server disconnect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (52.218.31.16:443)
alert: [12:05:30.708] Set status_code on  1 flows.
info: [12:05:35.333][[::1]:61529] server connect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.66.150:443)
info: [12:05:41.426][[::1]:61529] server disconnect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.66.150:443)
alert: [12:05:48.209] Set status_code on  1 flows.
info: [12:05:51.027][[::1]:61529] server connect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.68.30:443)
info: [12:05:57.108][[::1]:61529] server disconnect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.68.30:443)
alert: [12:06:00.003] Set status_code on  1 flows.
info: [12:06:04.428][[::1]:61529] server connect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.68.30:443)
info: [12:06:10.515][[::1]:61529] server disconnect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.68.30:443)
alert: [12:06:20.968] Set status_code on  1 flows.
info: [12:06:24.165][[::1]:61529] server connect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.65.163:443)
info: [12:06:30.277][[::1]:61529] server disconnect micktwomey-scratch-example.s3.eu-west-1.amazonaws.com:443 (3.5.65.163:443)
alert: [12:06:31.475] Set status_code on  1 flows.
info: [12:06:33.294][[::1]:61529] client disconnect
```
