-- Split a string in a table based of a delimiter
function github_api.split_string(s, delimiter)--split a string
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end