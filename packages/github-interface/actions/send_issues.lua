event = ["issues_request_received"]
priority = 1
input_parameters = ["request"]

require "packages.github-interface.github-api-functions.base"
require "packages.github-interface.github-api-functions.split_string_to_array"
require "packages.github-interface.github-api-functions.combine_unique_strings"
require "packages.github-interface.github-api-functions.add_request_param"
require "packages.github-interface.github-api-functions.organize_issues"
require "packages.github-interface.github-api-functions.add_api_authentication"
require "packages.github-interface.github-api-functions.get_table_summary_filters"
require "packages.github-interface.github-api-functions.string_to_github_filter"
-- require "packages.github-interface.github-api-functions.combine_filters"
require "packages.github-interface.github-api-functions.get_table_values_by_key"
-- require "packages.github-interface.github-api-functions.format_filters"
require "packages.github-interface.github-api-functions.table_to_array"
require "packages.github-interface.github-api-functions.table_to_matrix"
require "packages.github-interface.github-api-functions.set_selected_filters"
require "packages.github-interface.github-api-functions.create_filters"
require "packages.github-interface.github-api-functions.issues_request"
require "packages.github-interface.github-api-functions.issues_main"
-- require "packages.github-interface.github-api-functions.set_issues_tags_values"
require "packages.github-interface.github-api-functions.get_selected_tags"


local issues, summary_fields_values, tags_matrix, tags_selected_row = github_api.issues_main(request.query)


response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("issues.html", {
        issues = issues,
        summary_fields = summary_fields_values,
        tags_matrix = tags_matrix,
        tags_selected_row = tags_selected_row,
    })
}

return response
