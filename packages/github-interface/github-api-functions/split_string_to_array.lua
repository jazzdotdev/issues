function github_api.split_string_to_array(s, delimiter)
    -- Split a string into an array based on a delimiter
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end