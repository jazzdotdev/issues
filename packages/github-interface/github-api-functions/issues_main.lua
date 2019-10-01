function github_api.issues_main(query)
    local issues, summary_fields = github_api.issues_request(
        query['query'],
        query['key_word'],
        query['type']
    )
    local all_tags = {}

    issues, all_tags = github_api.organize_issues(issues, all_tags)

    -- log.debug(json.from_table(all_tags))
    all_tags = github_api.set_selected_filters(query, all_tags)
    -- log.debug(json.from_table(all_tags))

    local tags_matrix = github_api.table_to_matrix(
        all_tags,
        3,
        function(a, b) return a.name < b.name end
    )

    local tags_selected_row = github_api.get_selected_tags(tags_matrix)


    return issues, summary_fields, tags_matrix, tags_selected_row



end