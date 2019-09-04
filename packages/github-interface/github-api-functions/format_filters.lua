-- returns an array of the clean filters in the query format and in github format
function github_api.format_filters(query, summary_filters)
    local all_filters = ""

    all_filters = github_api.combine_filters(
        summary_filters ,
        github_api.format_checkbox_filters(query))
    -- all_filters = selectionFilters(query)

    return github_api.clean_filters(all_filters), all_filters
end