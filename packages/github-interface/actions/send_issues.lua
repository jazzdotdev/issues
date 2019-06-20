event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

local url = "https://api.github.com/search/issues?q={lighttouch}"
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
  -- Issue comments

  issue.el_comments = {}
  if issue.comments > 0 then
    local comment_response = send_request(issue.comments_url)
    local comments = comment_response.body
    for _,comment in ipairs(comments) do
      table.insert(issue.el_comments,{
          author = comment.user.login,
          body = comment.body
        }
      )
    end
  end -- end Issue comments

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
