function documents_model.group_documents(model_name, field_name, field_value, filters, lazy_filter)
    -- groups documents of same model in a key table using the values in the
    -- field_name as key and filling that key with the different models field_value
    local docs = documents_model.list_documents('tag', filters, lazy_filter, true)
    local result = {}
    local field_result = 'grouped_' .. field_value
    for _,val in pairs(docs.documents) do
        result[val[field_name]] = val
        if result[val[field_name]][field_result] == nil then
            result[val[field_name]][field_result] = {}
        end
        result[val[field_name]][field_result][val[field_value]] = val[field_value]
    end

    return result
end