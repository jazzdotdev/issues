priority = 3
input_parameter = "request"
events_table = ["issues_request_received"]

request.method == "GET"
and
#request.path_segments == 1
and
request.path_segments[1] == "issues"