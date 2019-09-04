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
require "packages.github-interface.github-api-functions.clean_filters"
require "packages.github-interface.github-api-functions.combine_filters"
require "packages.github-interface.github-api-functions.format_checkbox_filters"
require "packages.github-interface.github-api-functions.format_filters"
require "packages.github-interface.github-api-functions.tags_to_array"
require "packages.github-interface.github-api-functions.tags_to_matrix"
require "packages.github-interface.github-api-functions.set_selected_filters"


local summary_filters, summary_fields = github_api.summary_field_filters(
    request.query.title,
    request.query.body,
    request.query.comments
  )

local github_filters, query_filters = github_api.format_filters(
  request.query,
  summary_filters
)

local url = "https://api.github.com/search/issues?q={ type:issue ".. github_filters .." lighttouch }" --adding query filters in the url before making the requests

url = github_api.add_api_authentication(url) --adding github app auth if it was added in the lighttouch.scl

local github_response = send_request(url) --get request to the api

local issues = github_response.body.items
local all_tags = {}

issues, all_tags = github_api.organize_issues(issues, all_tags)

all_tags = github_api.set_selected_filters(request.query, all_tags)

local tags_matrix, tags_selected_row = github_api.tags_to_matrix(all_tags)


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
