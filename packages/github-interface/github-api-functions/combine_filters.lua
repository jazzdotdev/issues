function github_api.combine_filters(filters_1 , filters_2) --combines previouse filters and current ones
    local combined_filters = ""

    if filters_1 then
        for _,field in pairs(github_api.split_string(filters_1,",")) do
        --cleaning current filters
        combined_filters = github_api.check_repeated(combined_filters,field .. ',')
        end
    end
    if filters_2 then
        for _,field in pairs(github_api.split_string(filters_2,",")) do
        -- cleaning previous filters
        combined_filters = github_api.check_repeated(combined_filters,field .. ',')
        end
    end
    return combined_filters
end