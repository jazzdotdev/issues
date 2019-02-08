event = ["request_received"]
priority = 1
input_parameters = ["request"]

response = {
  headers = {
    ["content-type"] = "text/html",
  },
  body = render("index.html", {SITENAME="Hello World"})
}

return response
