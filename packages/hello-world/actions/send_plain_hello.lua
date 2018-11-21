event: ["request_received"]
priority: 1
input_parameters: ["request"]

response = {
  headers = {
    ["content-type"] = "text/plain",
  },
  body = "hello"
}

return response
