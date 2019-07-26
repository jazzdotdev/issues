event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

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
  --adding client id to the request url
  if settings.github_client_id then
    param_url = addParameterToURL(param_url,"client_id",settings.github_client_id)
  end
  --adding client secret to the request url
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

-- stops a string to have repeated patterns
-- to avoid having multiple of the same filter
function sanitizeString(main_s, added_s )
  if string.find( main_s, added_s, 1) then
    -- the added_s already belongs to the main_s
    log.debug("main" .. main_s)
    return main_s
  end
  log.debug("concatenated" .. main_s .. added_s)

  return main_s .. added_s
end

--currently only filtering labels
function addFilters( _filters , previous_filters)
  -- if filters is nil and previous filters is not nil
  if not _filters and previous_filters then
    -- current filters is nil but previous ones are not
    return previous_filters

  elseif not previous_filters then
    --without previous filters or current filters
    return ""
  end

  local result = ""
  -- local filter_labels = split(_filters,",")

  --spliting the filters in a table from filter text separting by commas ,
  for _,field in pairs(split(_filters,",")) do
    local name, value = field:match("^(.+):(.+)$")

    if value then --if the filter has the right format value will not be null

      if name == "body" or name == "title" or name == "comments" then
        --adding filter when it is body,title or comments
        -- it will filter issues that have the written text whitin the field
        result = sanitizeString(result,' \"' .. value .. '\"in:' .. name)

      elseif name == "label" then
        -- will filter for the specific written label
        result = sanitizeString(result,' ' .. name .. ':\"' .. value .. '\"')

      else
        -- if not any of the previous ones will assume it is a custom tag based of a label
        -- the label will be replace the name/value
        result = sanitizeString(result , ' label:\"' .. name .. "/".. value ..  '\"')

      end--end if types of filters

    end --end if value not null

  end -- end for adding filters

  if previous_filters then --add the previous filters if there are any
    for _,filter in pairs(split(previous_filters," ")) do
      result = sanitizeString(result," " .. filter)
    end
  end

  return result
end

local currentfilters = addFilters(request.query.filters,request.query.previous_filters)
local url = "https://api.github.com/search/issues?q={ type:issue ".. currentfilters .." lighttouch }" --adding query filters in the url before making the requests

url = addAuth(url) --adding github app auth if it was added in the lighttouch.scl

local github_response = send_request(url) --get request to the api

local issues = github_response.body.items
local all_tags = {}

for _, issue in ipairs(issues) do

  issue.min_body = string.sub(issue.body,0,150)

  issue.tags = {}
  for _, label in ipairs(issue.labels) do
    local name, value = label.name:match("^(.+)/(.+)$")
    if name then
      -- each name "issue, value, size, etc.."
      issue.tags[name] = value

      -- if the name storage is nil create it
      if all_tags[name] == nil then
        all_tags[name] = {} --all the custom fields names are in variable to show them in columns
      end
      -- if the values storage is nil create it
      if all_tags[name]['values'] == nil then
        all_tags[name]['values'] = {}
      end
      -- for each name store the name
      all_tags[name]['name'] = name
      -- for each name store all possible values
      all_tags[name]['values'][value] = value

    end
  end

  -- Issue comments
  --structuring comments in a table of all comments of the issue with
  -- the fields author and body
  issue.el_comments = {}
  if issue.comments > 0 then
    local comment_response = send_request(addAuth(issue.comments_url)) --get request to the comments
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
    previous_filters = currentfilters,
  })
}

return response
