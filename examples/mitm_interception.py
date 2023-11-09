import logging

from mitmproxy import flowfilter
from mitmproxy import http


class RateLimitExceededFilter:
    filter: flowfilter.TFilter

    def __init__(self):
        self.filter = flowfilter.parse("~d s3.eu-west-1.amazonaws.com & ~s")

    def response(self, flow: http.HTTPFlow) -> None:
        if flowfilter.match(self.filter, flow):
            logging.info(f"Flow {flow.request} matches filter: setting HTTP 429")
            flow.response.status_code = 429
            flow.response.reason = "Too Many Requests"


addons = [RateLimitExceededFilter()]
