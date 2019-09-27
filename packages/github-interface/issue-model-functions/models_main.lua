function documents_model.models_main(model_name, filters,tag_filters)


    local issues = documents_model.list_documents(model_name, filters, true, true)

    for i,issue in ipairs(issues.documents) do
        local subdocuments = documents_model.list_subdocuments(model_name, issue.uuid, true)
        issues.documents[i]['subdocuments'] = subdocuments
        issues.documents[i]['html_url'] = '/' .. issue.model .. '/' .. issue.uuid
        issues.documents[i]['min_body'] = string.sub(issue.body,0,150)
        issues.documents[i]['id'] = issue.uuid
        issues.documents[i]['el_comments'] = issue.subdocuments.comment

        local issue_tags = documents_model.read_m2m_model(issue.uuid,'issue','issue_tag','tag')

        issues.documents[i]['tags'] = documents_model.array_to_table(issue_tags,'name',true,'value')

    end

    local tags = documents_model.group_documents(
        'tag', --
        'name', --
        'value', --
        'values', --
        tag_filters, --
        true --
    )
    tags = github_api.table_to_matrix(
        tags,
        3,
        function(a, b) return a.name < b.name end
    )

    return issues, tags
end