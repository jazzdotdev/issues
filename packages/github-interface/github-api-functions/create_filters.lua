function github_api.create_filters(query)
    -- creating the title,body,comments filters and savinf their values
    local summary_filters, summary_fields_values = github_api.summary_field_filters(
        query.title,
        query.body,
        query.comments
        )
    local github_filters = github_api.format_filters(
        query,
        summary_filters
    )
    return github_filters, summary_fields_values
end