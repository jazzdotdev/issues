function github_api.get_table_values_by_key(table_array, delimiter)
    -- Turn the selected checkbox into the string filter format
    local selected_filters = ""
    for k,value in pairs(table_array) do
        if string.find(k,delimiter) then
            selected_filters = selected_filters .. "," .. value
        end
    end
    return selected_filters
end