function documents_model.retain_table_documents(
    docs_table_main,
    docs_table_retain
)
    -- params are both expected to be key delimited tables

    local result = {}


    for k,v in pairs(docs_table_retain) do
        if docs_table_main[k] then
            result[k] = v
        end
    end

    return result
end

function documents_model.compare_docs( array, matrix, index)
    -- star of the method index must be 2 , and array equals to matrix[1]
    local compared = {}

    if matrix[index] then
        compared = documents_model.retain_table_documents(
            array,
            matrix[index]
        )
    end

    if matrix[index + 1]  then
        return documents_model.compare_docs(compared, matrix, index + 1)
    end

    return compared
end


function documents_model.get_docs_intersection(docs_matrix, field_name)
    -- parameter is a matrix of douments for it to combine only the ones that are in all
    -- columns
    local result = {}
    local table_matrix = {}

    for i,row in ipairs(docs_matrix) do

        table_row = documents_model.array_to_table(row, field_name, false, '')

        table.insert(table_matrix, table_row)
    end

    result = documents_model.compare_docs(table_matrix[1], table_matrix, 2)

    log.debug('result')
    log.debug(
        json.from_table(
            result
        )
    )
    return result
end