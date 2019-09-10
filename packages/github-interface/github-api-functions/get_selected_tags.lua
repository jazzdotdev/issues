function github_api.get_selected_tags(tags_matrix)
    local tags_selected_row = {}

    for i,val in ipairs(tags_matrix) do
        for _,value in ipairs(val) do
            if value['has_checked'] == true then
                tags_selected_row[i] = true
            elseif not tags_selected_row[i] then
                -- if it is false left it in false
                tags_selected_row[i] = false
            end
        end
    end
    return tags_selected_row
end