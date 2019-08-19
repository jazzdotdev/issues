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
-- if the pattern is not in the main string is it added
function sanitizeString(main_s, added_s )
  if string.find( main_s, added_s, 1) then
    -- the added_s already belongs to the main_s
    return main_s
  end

  return main_s .. added_s
end





function formatFilters( string_filter )
  --formats the filter into the github query format
  local result = ""
  for _,field in pairs(split(string_filter,",")) do
    local name, value = field:match("^(.+):(.+)$")

    if value then --if the filter has the right format value will not be null
      if name == "body" or name == "title" or name == "comments" then
        -- filter for text in body or title or comments
        result = sanitizeString(result,' \"' .. value .. '\"in:' .. name)

      elseif name == "label" then
        -- will filter for the specific written label
        result = sanitizeString(result,' ' .. name .. ':\"' .. value .. '\"')
      else
        -- default filter is a label filter
        result = sanitizeString(result , ' label:\"' .. name .. "/".. value ..  '\"')

      end--end if types of filters

    end --end if value not null

  end -- end for adding filters

  return result
end




-- filters selected with the checkbox inputs
function selectionFilters(query)
  local selected_filters = ""
  for k,value in pairs(query) do
    if string.find(k,"selection") then
      selected_filters = selected_filters .. "," .. value
    end
  end
  return selected_filters
end


function combineFilters(filters_1 , filters_2) --combines previouse filters and current ones
  local combined_filters = ""

  if filters_1 then
    for _,field in pairs(split(filters_1,",")) do
      --cleaning current filters
      combined_filters = sanitizeString(combined_filters,field .. ',')
    end
  end
  if filters_2 then
    for _,field in pairs(split(filters_2,",")) do
      -- cleaning previous filters
      combined_filters = sanitizeString(combined_filters,field .. ',')
    end
  end
  return combined_filters
end

--currently only filtering labels
function createFilters( filters ,query)
  -- returns an array of the clean filters in the query format and in github format
  local all_filters = ""

  all_filters = combineFilters(filters , selectionFilters(query))

  return formatFilters(all_filters), all_filters
end



local github_filters, query_filters = createFilters(
  request.query.filters,
  request.query
)

local url = "https://api.github.com/search/issues?q={ type:issue ".. github_filters .." lighttouch }" --adding query filters in the url before making the requests

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
      all_tags[name]['values'][value] = {}
      all_tags[name]['values'][value]['value'] = value
      all_tags[name]['values'][value]['is_checked'] = false

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

  -- Right id number

  issue.number_id = send_request(addAuth(issue.url)).body.number

end

-- log.debug("Status: ", github_response.status)
-- log.debug("Content length: ", #github_response.body_raw)

log.debug("Query: " .. json.from_table(request.query))

for k,v in pairs(request.query) do
  if string.find(k,"selection") then
    local name, value = v:match("^(.+):(.+)$")

    -- especial check for empty values
    if all_tags[name] == nil then
      all_tags[name] = {}
      all_tags[name]['name'] = name
      all_tags[name]['values'] = {}
      all_tags[name]['values'][value] = {}
    end
    if all_tags[name]['values'][value] == nil then
      all_tags[name]['values'][value] = {}
    end
    if all_tags[name]['values'][value]['value'] == nil  then
      all_tags[name]['values'][value]['value'] = value
    end
    -- end special check for empty values

    --average check for values
    if all_tags[name]['values'][value]['value'] then
      all_tags[name]['has_checked'] = true
      all_tags[name]['values'][value]['is_checked'] = true
    end
  end
end

response = {
  headers = {
    ["content-type"] = "text/html",
  },
  body = render("issues.html", {
    issues = issues,
    all_tags = all_tags,
    previous_filters = query_filters,
  })
}

return response
