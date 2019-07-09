event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

function addParameterToURL( url,name,value)
  local url_c = url

  if string.find(url_c,"?") then
    url_c = url_c .. "&" .. name .. "=" .. value
  else
    url_c = url_c .. "?" .. name .. "=" .. value
  end

  return url_c
end

function addAuth( param_url )
  if settings.github_client_id then
    param_url = addParameterToURL(param_url,"client_id",settings.github_client_id)
  end

  if settings.github_client_secret then
    param_url = addParameterToURL(param_url,"client_secret",settings.github_client_secret)
  end
  return param_url
end

local url = addAuth("https://api.github.com/search/issues?q={lighttouch}")



local github_response = send_request(url)

local issues = github_response.body.items
local all_tags = {}

for _, issue in ipairs(issues) do
  issue.tags = {}
  for _, label in ipairs(issue.labels) do
    local name, value = label.name:match("^(.+)/(.+)$")
    if name then
      issue.tags[name] = value
      all_tags[name] = name
    end
  end

  -- Issue comments
  issue.el_comments = {}
  if issue.comments > 0 then
    local comment_response = send_request(addAuth(issue.comments_url))
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
  body = render("issues.html", {issues = issues,all_tags = all_tags })
}

return response
