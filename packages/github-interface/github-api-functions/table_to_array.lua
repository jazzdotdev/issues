function github_api.table_to_array( table_map, sort_function )
    -- turns a key base table into an indexed one
    local i = 1
    local array = {}

    for k,value in pairs(table_map) do
        array[i] = value
        i = i + 1
    end

    -- order the array with the sort function
    if sort_function then
        table.sort(array, sort_function)
    end

    return array
end