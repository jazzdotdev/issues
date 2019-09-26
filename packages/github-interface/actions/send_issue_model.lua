event = ["request_model_table"]
priority = 2
input_parameters = ["request"]


-- require "packages.github-interface.github-api-functions.split_string_to_array"
-- require "packages.github-interface.github-api-functions.add_request_param"
-- require "packages.github-interface.github-api-functions.organize_issues"
-- require "packages.github-interface.github-api-functions.add_api_authentication"
-- require "packages.github-interface.github-api-functions.set_selected_filters"
-- require "packages.github-interface.github-api-functions.issues_request"
-- require "packages.github-interface.github-api-functions.issues_main"
-- require "packages.github-interface.github-api-functions.get_selected_tags"
-- require "packages.github-interface.github-api-functions.table_to_gitfilters"
-- require "packages.github-interface.github-api-functions.values_to_filter_table"
-- require "packages.github-interface.github-api-functions.tag_to_label"
-- require "packages.github-interface.github-api-functions.build_api_url"
require "packages.github-interface.github-api-functions.base"
require "packages.github-interface.github-api-functions.table_to_array"
require "packages.github-interface.github-api-functions.table_to_matrix"


require "packages.github-interface.issue-model-functions.base"
require "packages.github-interface.issue-model-functions.models_main"
require "packages.github-interface.issue-model-functions.list_documents"
require "packages.github-interface.issue-model-functions.list_subdocuments"
require "packages.github-interface.issue-model-functions.read_m2m_model"
require "packages.github-interface.issue-model-functions.group_documents"


local filters = {}
local model_name = 'issue'
local tag_filters = {}

local issues = documents_model.models_main(model_name, filters)

local tags = documents_model.group_documents('tag','name','value',tag_filters,true)
log.debug(json.from_table(tags))
-- tags = github_api.table_to_matrix(
--     tags,
--     3,
--     function(a, b) return a.name < b.name end
-- )
-- log.debug(json.from_table(issues.documents[1]))

response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("issue_model.html", {
        issues = issues.documents,
        -- summary_fields = summary_fields,
        -- tags_matrix = tags_matrix,
        -- tags_selected_row = tags_selected_row,
    })
}

return response