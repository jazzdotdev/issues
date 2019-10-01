event = ["request_model_table"]
priority = 4
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
require "packages.github-interface.issue-model-functions.array_to_table"


local filters = {}
local model_name = 'issue'
local tag_filters = {}

local issues, tags = documents_model.models_main(model_name, filters,tag_filters)

log.debug(json.from_table(request.query))

local summary_fields = { -- default fields that will go in the summary column
        has_values = false,
        title_model = {
            name="title",
            value=""
        },
        body_model = {
            name="body",
            value=""
        },
        comments_model = {
            name="comments",
            value=""
        }
    }

for k,v in pairs(request.query) do
    if summary_fields[k] then
        summary_fields[k].value = v
    end
end

response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("issue_model.html", {
        issues = issues.documents,
        summary_fields = summary_fields,
        tags_matrix = tags,
        model_table = true,
        -- tags_selected_row = tags_selected_row,
    })
}

return response