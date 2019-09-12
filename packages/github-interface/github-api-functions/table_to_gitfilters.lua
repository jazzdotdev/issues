function github_api.table_to_gitfilters(query, filters_format, flag)
    local gitfilter = ""
    local filter_val, filters_values = github_api.values_to_filter_table(
        query,
        filters_format,
        "selection"
    )

    for _,value in ipairs(filter_val) do
        for k,val in pairs(value) do
            if filters_format[k] then
                local s = string.gsub(filters_format[k],flag,val)
                gitfilter = gitfilter .. " " .. s
            end
        end
    end
    return gitfilter, filters_values
end