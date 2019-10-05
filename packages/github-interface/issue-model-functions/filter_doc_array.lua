function documents_model.filter_doc_array(model_array, filters, lazy_filter)
    local result = {}

    for k,value in pairs(model_array) do
        local valid = false
        for key,val in pairs(filters) do
            if lazy_filter then
                if string.find(value[key], val) then
                    valid = true
                end
            else
                if value[key] == val then
                    valid = true
                end
            end

        end

        if valid then
            table.insert(result, value)
        end
    end
    return result
end