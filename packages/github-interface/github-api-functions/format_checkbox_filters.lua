function github_api.format_checkbox_filters(query)
    -- Turn the selected checkbox into the string filter format
    local selected_filters = ""
    for k,value in pairs(query) do
        if string.find(k,"selection") then
            selected_filters = selected_filters .. "," .. value
        end
    end
    return selected_filters
end