function github_api.tags_to_array( issues_tags )
    -- Orders the all the tags in the issues into an array
    local i = 1
    local tags_array = {}

    for k,value in pairs(issues_tags) do
        tags_array[i] = value
        i = i + 1
    end

    -- order the array in gramatical order of the tags name
    table.sort(tags_array,function(a, b) return a.name < b.name end)

    return tags_array
end