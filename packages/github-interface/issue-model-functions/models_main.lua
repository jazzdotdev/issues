function documents_model.models_main(model_name, filters)


    local issues = documents_model.list_documents(model_name, filters, true, true)

    for i,issue in ipairs(issues.documents) do
        local subdocuments = documents_model.list_subdocuments(model_name, issue.uuid, true)
        issues.documents[i]['subdocuments'] = subdocuments
        issues.documents[i]['html_url'] = '/' .. issue.model .. '/' .. issue.uuid
        issues.documents[i]['min_body'] = string.sub(issue.body,0,150)
        issues.documents[i]['id'] = issue.uuid
        issues.documents[i]['el_comments'] = issue.subdocuments.comment

    end

    -- log.debug(json.from_table(issues.documents[1].subdocuments.issue_tag))
    local test_uuid = issues.documents[1].uuid
    -- log.debug(test_uuid)
    local tags = documents_model.read_m2m_model(test_uuid,'issue','issue_tag','tag')
    log.debug(json.from_table(tags))

    return issues
end