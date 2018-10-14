event: ["request_received"]
priority: 1

response = {
  headers = {
    ["content-type"] = "text/plain",
  },
  body = "hello"
}

return response
