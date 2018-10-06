event: ["request_received"]
priority: 1

print("Hi")
  
print("send_plain_hello handler")
response = {
  headers = {
    ["content-type"] = "text/plain",
  },
  body = "hello"
}

print("response")
return response

