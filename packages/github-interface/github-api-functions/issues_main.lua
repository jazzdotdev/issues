function github_api.issues_main(query)
    local issues, summary_fields_values = github_api.execute_issues_petition(query)
    local all_tags = {}

    issues, all_tags = github_api.organize_issues(issues, all_tags)

    all_tags = github_api.set_selected_filters(query, all_tags)

    local tags_matrix, tags_selected_row = github_api.tags_to_matrix(all_tags)

    return issues, summary_fields_values, tags_matrix, tags_selected_row
end