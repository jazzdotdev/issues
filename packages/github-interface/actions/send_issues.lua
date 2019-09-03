event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

require "packages.github-interface.github-api-functions.base"
require "packages.github-interface.github-api-functions.split_string"
require "packages.github-interface.github-api-functions.check_repeated"
require "packages.github-interface.github-api-functions.add_request_param"
require "packages.github-interface.github-api-functions.organize_issues"
require "packages.github-interface.github-api-functions.add_api_authentication"
require "packages.github-interface.github-api-functions.summary_field_filters"
require "packages.github-interface.github-api-functions.filter_formatter"
require "packages.github-interface.github-api-functions.combine_filters"
require "packages.github-interface.github-api-functions.checkbox_filters"
require "packages.github-interface.github-api-functions.generate_filters"


local summary_filters, summary_fields = github_api.summary_field_filters(
    request.query.title,
    request.query.body,
    request.query.comments
  )

local github_filters, query_filters = github_api.generate_filters(
  request.query,
  summary_filters
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
