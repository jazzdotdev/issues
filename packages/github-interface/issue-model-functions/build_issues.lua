function documents_model.build_issues(issues,model_name)

    for i,issue in ipairs(issues) do
        local subdocuments = documents_model.list_subdocuments(model_name, issue.uuid, true)
        issues[i]['subdocuments'] = subdocuments
        issues[i]['html_url'] = '/' .. issue.model .. '/' .. issue.uuid
        issues[i]['min_body'] = string.sub(issue.body,0,150)
        issues[i]['id'] = issue.uuid
        issues[i]['el_comments'] = issue.subdocuments.comment

        local issue_tags = documents_model.read_m2m_model(issue.uuid,'issue','issue_tag','tag')
        if issue_tags ~= nil then
            issues[i]['tags'] = documents_model.array_to_table(issue_tags,'name',true,'value')
        end


    end

    return issues
end