function github_api.tags_to_matrix(issues_tags)

    local tags_matrix = {}
    local selected_tags_row = {}
    local tags_array = github_api.tags_to_array( issues_tags )

    local j = 1 --columns
    local i = 1 -- rows
    for _,value in ipairs(tags_array) do
        if tags_matrix[i] == nil then
            tags_matrix[i] = {}
        end
        tags_matrix[i][j] = value  -- Row i and column j of the matrix
        if value['has_checked'] == true then
            selected_tags_row[i] = true
        elseif not selected_tags_row[i] then -- if it is false left it in false
            selected_tags_row[i] = false
        end
        j = j + 1
        if j > 3 then
            j = 1
            i = i + 1
        end
    end

    return tags_matrix, selected_tags_row
end