priority = 3
input_parameter = "request"
events_table = ["request_model_table"]

request.method == "GET"
and
#request.path_segments == 2
and
request.path_segments[1] == "table"
and
request.path_segments[2] == "model_issues"
or
request.query.selection
or
request.query.title_model
or
request.query.body_model
or
request.query.comments_model