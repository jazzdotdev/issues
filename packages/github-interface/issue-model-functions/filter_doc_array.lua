function documents_model.filter_doc_array(model_array, filters, lazy_filter)
    local result = {} -- table array of all the valid documents
    local valid

    for _,value in pairs(model_array) do
        valid = true
        for key,val in pairs(filters) do
            if lazy_filter then
                if not string.find(value[key], val) then
                    valid = false
                end
            else
                if value[key] ~= val then
                    valid = false
                end
            end

        end

        if valid then
            table.insert(result, value)
        end
    end
    return result
end