event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

local url = "https://api.github.com/search/issues?q={%22lighttouch%22}"

local github_response = send_request(url)

local issues = github_response.body.items
for _, issue in ipairs(issues) do
  issue.tags = {}
  for _, label in ipairs(issue.labels) do
    local name, value = label.name:match("^(.+)/(.+)$")
    if name then
      issue.tags[name] = value
    end
  end
end

print("Status: ", github_response.status)
print("Content length: ", #github_response.body_raw)

response = {
  headers = {
    ["content-type"] = "text/html",
  },
  body = render("issues.html", {issues = issues})
}

return response
