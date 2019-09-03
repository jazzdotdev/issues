event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

require "packages.github-interface.github-api-functions.base"
require "packages.github-interface.github-api-functions.split_string"
require "packages.github-interface.github-api-functions.check_repeated"
require "packages.github-interface.github-api-functions.add_request_param"
require "packages.github-interface.github-api-functions.organize_issues"
require "packages.github-interface.github-api-functions.add_api_authentication"

local summary_fields = {
  title = {
    name = 'title',
  },
  body =  {
    name = 'body',
  },
  comments = {
    name = 'comments',
  },
}

function summaryFilters( f_title, f_body, f_comments )
  summaryFilters = ""
  if f_title then
    summaryFilters = summaryFilters .. ',title:' .. f_title
    summary_fields['title']['value'] = f_title
  end
  if f_body then
    summaryFilters = summaryFilters .. ',body:' .. f_body
    summary_fields['body']['value'] = f_body

  end
  if f_comments then
    summaryFilters = summaryFilters .. ',comments:' .. f_comments
    summary_fields['comments']['value'] = f_comments
  end

  return summaryFilters
end


function formatFilters( string_filter )
  --formats the filter into the github query format
  local result = ""
  for _,field in pairs(github_api.split_string(string_filter,",")) do
    local name, value = field:match("^(.+):(.+)$")

    if value then --if the filter has the right format value will not be null
      if name == "body" or name == "title" or name == "comments" then
        -- filter for text in body or title or comments
        result = github_api.check_repeated(result,' \"' .. value .. '\"in:' .. name)

      elseif name == "label" then
        -- will filter for the specific written label
        result = github_api.check_repeated(result,' ' .. name .. ':\"' .. value .. '\"')
      else
        -- default filter is a label filter
        result = github_api.check_repeated(result , ' label:\"' .. name .. "/".. value ..  '\"')

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
    for _,field in pairs(github_api.split_string(filters_1,",")) do
      --cleaning current filters
      combined_filters = github_api.check_repeated(combined_filters,field .. ',')
    end
  end
  if filters_2 then
    for _,field in pairs(github_api.split_string(filters_2,",")) do
      -- cleaning previous filters
      combined_filters = github_api.check_repeated(combined_filters,field .. ',')
    end
  end
  return combined_filters
end


--currently only filtering labels
function createFilters(query, summary_filters)
  -- returns an array of the clean filters in the query format and in github format
  local all_filters = ""

  all_filters = combineFilters(summary_filters , selectionFilters(query))
  -- all_filters = selectionFilters(query)


  return formatFilters(all_filters), all_filters
end


local github_filters, query_filters = createFilters(
  request.query,
  summaryFilters(
    request.query.title,
    request.query.body,
    request.query.comments
  )
)

local url = "https://api.github.com/search/issues?q={ type:issue ".. github_filters .." lighttouch }" --adding query filters in the url before making the requests

url = github_api.add_api_authentication(url) --adding github app auth if it was added in the lighttouch.scl

local github_response = send_request(url) --get request to the api

local issues = github_response.body.items
local all_tags = {}

issues, all_tags = github_api.organize_issues(issues, all_tags)


-- log.debug("Status: ", github_response.status)
-- log.debug("Content length: ", #github_response.body_raw)

-- log.debug("Query: " .. json.from_table(request.query))

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


local i = 1
local tags_array = {}

for k,value in pairs(all_tags) do
  tags_array[i] = value
  i = i + 1
end

table.sort(tags_array,function(a, b) return a.name < b.name end)

i = 1 -- rows
local j = 1 --columns
local tags_matrix = {}
local tags_selected_row = {}

for _,value in ipairs(tags_array) do
  if tags_matrix[i] == nil then
    tags_matrix[i] = {}
  end
  tags_matrix[i][j] = value  -- Row i and column j of the matrix

  if value['has_checked'] == true then
    tags_selected_row[i] = true
  elseif not tags_selected_row[i] then -- if it is false left it in false
    tags_selected_row[i] = false
  end

  j = j + 1
  if j > 3 then
    j = 1
    i = i + 1
  end
end

response = {
  headers = {
    ["content-type"] = "text/html",
  },
  body = render("issues.html", {
    issues = issues,
    previous_filters = query_filters,
    tags_matrix = tags_matrix,
    tags_selected_row = tags_selected_row,
    summary_fields = summary_fields,
  })
}

return response
