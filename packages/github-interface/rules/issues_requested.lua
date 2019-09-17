priority = 3
input_parameter = "request"
events_table = ["issues_request_received"]

request.method == "GET"
and
#request.path_segments == 2
and
request.path_segments[1] == "table"
and
request.path_segments[2] == "issues"
or
request.query.selection
or
request.query.title
or
request.query.body
or
request.query.comments