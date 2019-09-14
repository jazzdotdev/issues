function github_api.values_to_filter_table(query, table_filters_format, tag_key, filters_values)
    -- local tag_key = "selection"
    local filters = {}

    for k,value in pairs(query) do
        if table_filters_format[k] then
            filters_values[k] = value
        end

        if value ~= "" then
            if string.find(k,tag_key) then
                table.insert(filters, { label = github_api.tag_to_label(value) })
            elseif table_filters_format[k] then
                local temp_table = {}
                temp_table[k] = value
                table.insert(filters, temp_table)
            end
        end
    end
    return filters, filters_values
end
