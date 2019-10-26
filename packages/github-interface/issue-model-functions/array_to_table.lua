function documents_model.array_to_table(
    array,
    field_name,
    reduce_to_field,
    min_field
)
    -- turns an array into a table dict using the values of
    -- the field name in each object of the array as delimiter
    -- this will cause that there are no values with the same
    -- key name in the array

    -- reduce field is a boolean if the object is not desired
    -- min field is the name of the value that would be set instead of the table
    local result = {}

    for i,value in ipairs(array) do
        if not reduce_to_field then
            result[value[field_name]] = value
        else
            result[value[field_name]] = value[min_field]
        end
    end
    return result
end