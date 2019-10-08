function documents_model.build_issues(issues,model_name)
    local result = {}
    local i = 1 -- initial value
    for k,issue in pairs(issues) do
        local subdocuments = documents_model.list_subdocuments(
            model_name,
            issue.uuid,
            true
        )
        result[i] = issue
        result[i]['subdocuments'] = subdocuments
        result[i]['html_url'] = '/' .. issue.model .. '/' .. issue.uuid
        result[i]['min_body'] = string.sub(issue.body,0,150)
        result[i]['id'] = issue.uuid
        result[i]['el_comments'] = issue.subdocuments.comment

        local issue_tags = documents_model.read_m2m_model(issue.uuid,'issue','issue_tag','tag')
        if issue_tags ~= nil then
            result[i]['tags'] = documents_model.array_to_table(issue_tags,'name',true,'value')
        end
        i = i + 1
    end

    return result
end