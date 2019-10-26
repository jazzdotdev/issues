function documents_model.models_main(
    model_name,
    filters,
    filter_map,
    tag_filters,
    filters_table, query
)
    local issues

    local tags, chosen_tags = documents_model.build_tags(
        tag_filters,
        query
    )
    local tagged_issues = {}
    local tagged_issues_matrix = {}

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



    for i,tags in ipairs(chosen_tags) do
        -- for each tag get all documents that have it and put them in a matrix
        tagged_issues = documents_model.filter_doc_by_m2m(
            'issue',
            'issue_tag',
            'tag',
            tags
        )

        tagged_issues = documents_model.build_issues(tagged_issues, model_name)

        table.insert( tagged_issues_matrix, tagged_issues)
    end

    if chosen_tags[1] then
        -- if chosen tags has values compare with summary values
        table.insert( tagged_issues_matrix, issues)

        issues =  github_api.table_to_array(
            documents_model.get_docs_intersection(
                tagged_issues_matrix,
                'uuid'
            ),
            nil
        )
    end

    local tags_selected_row = github_api.get_selected_tags(tags)

    filters_table = documents_model.set_table_filters(filters_table, query)

    return issues, tags, filters_table, tags_selected_row
end