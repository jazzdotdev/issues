event = ["request_model_table"]
priority = 2
input_parameters = ["request"]


-- require "packages.github-interface.github-api-functions.base"
-- require "packages.github-interface.github-api-functions.split_string_to_array"
-- require "packages.github-interface.github-api-functions.add_request_param"
-- require "packages.github-interface.github-api-functions.organize_issues"
-- require "packages.github-interface.github-api-functions.add_api_authentication"
-- require "packages.github-interface.github-api-functions.table_to_array"
-- require "packages.github-interface.github-api-functions.table_to_matrix"
-- require "packages.github-interface.github-api-functions.set_selected_filters"
-- require "packages.github-interface.github-api-functions.issues_request"
-- require "packages.github-interface.github-api-functions.issues_main"
-- require "packages.github-interface.github-api-functions.get_selected_tags"
-- require "packages.github-interface.github-api-functions.table_to_gitfilters"
-- require "packages.github-interface.github-api-functions.values_to_filter_table"
-- require "packages.github-interface.github-api-functions.tag_to_label"
-- require "packages.github-interface.github-api-functions.build_api_url"

require "packages.github-interface.issue-model-functions.base"
require "packages.github-interface.issue-model-functions.list_documents"
require "packages.github-interface.issue-model-functions.list_subdocuments"

log.debug("Issue model table action")

local filters = {}

test_response = documents_model.list_documents('issue',filters, true, true)

for k,v in pairs(test_response.documents) do
    local temp = documents_model.list_subdocuments('issue',v.uuid, true)
end

response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("issue_model.html", {
        -- issues = issues,
        -- summary_fields = summary_fields,
        -- tags_matrix = tags_matrix,
        -- tags_selected_row = tags_selected_row,
    })
}

return response