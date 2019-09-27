function documents_model.group_documents(model_name, field_name, field_value, new_field_name, filters , lazy_filter)
    -- groups documents of same model in a key table using the values in the
    -- field_name as key and filling that key with the different models field_value
    local docs = documents_model.list_documents('tag', filters, lazy_filter, true)
    local result = {}
    for _,val in pairs(docs.documents) do
        if result[val[field_name]] == nil then
            result[val[field_name]] = {}
            result[val[field_name]]['model'] = val[model_name]
            result[val[field_name]][field_name] = val[field_name]
        end
        if result[val[field_name]][new_field_name] == nil then
            result[val[field_name]][new_field_name] = {}
        end
        if result[val[field_name]][new_field_name][val[field_value]] == nil then
            result[val[field_name]][new_field_name][val[field_value]] = {}
        end
        result[val[field_name]][new_field_name][val[field_value]][field_value] = val[field_value]
    end

    return result
end