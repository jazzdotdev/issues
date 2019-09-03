-- filters selected with the checkbox inputs
function github_api.checkbox_filters(query)
    local selected_filters = ""
    for k,value in pairs(query) do
        if string.find(k,"selection") then
        selected_filters = selected_filters .. "," .. value
        end
    end
    return selected_filters
end