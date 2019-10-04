function documents_model.models_main(model_name, filters, filter_map,tag_filters, filters_table, query)

    filters = documents_model.build_mapped_filters(filters,filter_map,query)

    local issues = documents_model.list_documents(model_name, filters, true, true)

    issues = documents_model.build_issues(issues.documents,model_name)

    local tags = documents_model.build_tags(tag_filters,query)

    local tags_selected_row = github_api.get_selected_tags(tags)

    filters_table = documents_model.set_table_filters(filters_table, query)

    return issues, tags, filters_table, tags_selected_row
end