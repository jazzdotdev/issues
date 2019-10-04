function documents_model.build_tags(tag_filters,query)

    local tags = documents_model.group_documents(
        'tag', --
        'name', --
        'value', --
        'values', --
        tag_filters, --
        true --
    )
    tags = github_api.set_selected_filters(query, tags)

    tags = github_api.table_to_matrix(
        tags,
        3,
        function(a, b) return a.name < b.name end
    )
    return tags
end