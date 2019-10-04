function github_api.issues_main(basic_config)
    local issues, summary_fields = github_api.issues_request(
        basic_config['query'],
        basic_config['key_word'],
        basic_config['type']
    )
    local all_tags = {}

    -- getting all the tags and  issues in the request
    issues, all_tags = github_api.organize_issues(issues, all_tags)

    --- in the tags that are in the request set the selected ones for the frontend
    all_tags = github_api.set_selected_filters(basic_config['query'], all_tags)


    local tags_matrix = github_api.table_to_matrix(
        all_tags,
        3,
        function(a, b) return a.name < b.name end
    )

    local tags_selected_row = github_api.get_selected_tags(tags_matrix)

    return issues, summary_fields, tags_matrix, tags_selected_row

end