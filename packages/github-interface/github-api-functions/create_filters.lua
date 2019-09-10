function github_api.create_filters(query)
    -- creating the title,body,comments filters and savinf their values
    local summary_filters, summary_fields_values = github_api.get_table_summary_filters(
        query.title,
        query.body,
        query.comments
        )


    local github_filters = github_api.string_to_github_filter(
        summary_filters .. ',' .. github_api.get_table_values_by_key(
            query,
            "selection"
        )
    )
    return github_filters, summary_fields_values
end