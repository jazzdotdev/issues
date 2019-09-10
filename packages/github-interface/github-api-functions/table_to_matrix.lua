function github_api.table_to_matrix(table, columns_amount)

    local matrix = {}
    local array = github_api.table_to_array(
        table,
        function(a, b) return a.name < b.name end
    )

    local j = 1 --columns
    local i = 1 -- rows
    for _,value in ipairs(array) do
        if matrix[i] == nil then
            matrix[i] = {}
        end
        matrix[i][j] = value  -- Row i and column j of the matrix
        j = j + 1
        if j > columns_amount then
            j = 1
            i = i + 1
        end
    end

    return matrix
end