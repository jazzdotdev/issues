priority = 4
input_parameter = "request"
events_table = ["request_model_table"]

request.method == "GET"
and
#request.path_segments == 2
and
request.path_segments[1] == "model_table"
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