event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

local url = "https://api.github.com/search/issues?q={%22lighttouch%22}"

local github_response = send_request(url)

print("Status: ", github_response.status)
print("Content length: ", #github_response.body_raw)

response = {
  headers = {
    --["content-type"] = "text/html",
    ["content-type"] = "application/json",
  },
  --body = render("issues.html")
  body = github_response.body_raw
}

return response
