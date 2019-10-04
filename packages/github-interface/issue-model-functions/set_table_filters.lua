function documents_model.set_table_filters(filters_table, query)

    for k,v in pairs(query) do
        if filters_table[k] then
            filters_table[k].value = v
            if v ~= "" then
                filters_table["has_selected"].value = true
            end
        end
    end
    return filters_table

end