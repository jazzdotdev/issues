function documents_model.models_main(model_name, filters, filter_map,tag_filters, filters_table, query)
    local issues


    filters = documents_model.build_mapped_filters(filters,filter_map,query)

    if query.comments_model ~= "" and query.comments_model ~= nil  then
        -- if the comments search query is not null nor empty
        -- first filtering by the comments

        issues = documents_model.filter_doc_by_subdoc(
            'comment',
            model_name,
            {body=query.comments_model},
            true
        )

        issues = documents_model.filter_doc_array(
            issues, filters,true
        )

    else
        issues = documents_model.list_documents(model_name, filters, true, true).documents
    end

    issues = documents_model.build_issues(issues,model_name)

    local tags, chosen_tags = documents_model.build_tags(
        tag_filters,
        query
    )

    
    -- issues = documents_model.group_docs_table_fields(
        --     issues,
        --     'issue_tags',
        --     chosen_tags
        -- )
    log.debug(json.from_table(chosen_tags))

    if chosen_tags[1] then
        issue_temp = documents_model.filter_doc_by_m2m(
            'issue',
            'issue_tag',
            'tag',
            chosen_tags[1]
        )

        issue_temp = documents_model.build_issues(issue_temp,model_name)
        
        for k,v in pairs(issue_temp) do
            log.debug(json.from_table(v.issue_tags))
        end
    end


    local tags_selected_row = github_api.get_selected_tags(tags)

    filters_table = documents_model.set_table_filters(filters_table, query)

    return issues, tags, filters_table, tags_selected_row
end