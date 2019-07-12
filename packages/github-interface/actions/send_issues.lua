event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

-- to avoid null pointer if the value is not present it will be an empty string
function isStringPresent( string )
  if string then
    return string
  else
    return ""
  end
end

local filters = isStringPresent(request.query.filters)

--Method to add extra parameters to a github request
function addParameterToURL( url,name,value)
  local url_c = url
  --checking if the url has the character ? for parameters
  if string.find(url_c,"?") then
    -- if it has the ? character then add a new field with an &
    url_c = url_c .. "&" .. name .. "=" .. value
  else
    -- if the string url doesn't have the ? character add it
    url_c = url_c .. "?" .. name .. "=" .. value
  end
  return url_c
end

-- Method to add client secret and client id for request authentication of the github api
function addAuth( param_url )
  --adding cleint id to the request url
  if settings.github_client_id then
    param_url = addParameterToURL(param_url,"client_id",settings.github_client_id)
  end
  --adding client secrete to the request url
  if settings.github_client_secret then
    param_url = addParameterToURL(param_url,"client_secret",settings.github_client_secret)
  end
  return param_url
end

-- Split a string in a table based of a delimiter
function split(s, delimiter)--split a string
  result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result;
end

--currently only filtering labels
function addFilters( _filters )
  if _filters == "" then
    return _filters
  end
  local result = ""
  local labels = split(_filters,",")--spliting in a table the filter text by commas ,
  for _,field in pairs(labels) do
    result = result .. ' label:\"' .. string.gsub( field,":","/") ..  '\"'
  end
  return result
end

local url = "https://api.github.com/search/issues?q={lighttouch type:issue ".. addFilters(filters) .."}"

url = addAuth(url)

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
  body = render("issues.html", {
    issues = issues,
    all_tags = all_tags,
  })
}

return response
