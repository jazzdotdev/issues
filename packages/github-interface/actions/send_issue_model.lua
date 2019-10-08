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
require "packages.github-interface.github-api-functions.set_selected_filters"
require "packages.github-interface.github-api-functions.get_selected_tags"


require "packages.github-interface.issue-model-functions.base"
require "packages.github-interface.issue-model-functions.models_main"
require "packages.github-interface.issue-model-functions.list_documents"
require "packages.github-interface.issue-model-functions.list_subdocuments"
require "packages.github-interface.issue-model-functions.read_m2m_model"
require "packages.github-interface.issue-model-functions.group_documents"
require "packages.github-interface.issue-model-functions.array_to_table"
require "packages.github-interface.issue-model-functions.set_table_filters"
require "packages.github-interface.issue-model-functions.build_issues"
require "packages.github-interface.issue-model-functions.build_tags"
require "packages.github-interface.issue-model-functions.build_mapped_filters"
require "packages.github-interface.issue-model-functions.filter_doc_by_subdoc"
require "packages.github-interface.issue-model-functions.filter_doc_array"


local issue_filters = {
    title="",
    body="",
}
local filter_map = {
    -- name of field in the model = name of the field in the query
    title = "title_model",
    body = "body_model",
}

local model_name = 'issue'
local tag_filters = {}
local summary_fields = { -- default fields that will go in the summary column
    has_selected = { -- centinel value to control if any of the other values in the table are not empty
        name="has_selected",
        value=false
    },
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

local issues, tags, summary_fields, tags_selected_row = documents_model.models_main(
    model_name,
    issue_filters,
    filter_map,
    tag_filters,
    summary_fields,
    request.query
)

response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("issue_model.html", {
        issues = issues,
        summary_fields = summary_fields,
        tags_matrix = tags,
        tags_selected_row = tags_selected_row,
    })
}

return response