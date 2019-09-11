function github_api.issues_main(query)
    local issues, summary_fields_values = github_api.issues_request(
        query,
        "lighttouch",
        "issue"
    )
    local all_tags = {}

    issues, all_tags = github_api.organize_issues(issues, all_tags)

    all_tags = github_api.set_selected_filters(query, all_tags)

    local tags_matrix = github_api.table_to_matrix(
        all_tags,
        3,
        function(a, b) return a.name < b.name end
    )

    local tags_selected_row = github_api.get_selected_tags(tags_matrix)


    return issues, summary_fields_values, tags_matrix, tags_selected_row



end