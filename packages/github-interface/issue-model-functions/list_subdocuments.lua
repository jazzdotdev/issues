function documents_model.list_subdocuments(model_name,id, all_fields)
    local subdocuments = {}

    contentdb.walk_documents(nil, function (doc_id, fields, body, store)
        if fields[model_name] == id then
            local docs = subdocuments[fields.model]
            if not docs then
                docs = {}
                subdocuments[fields.model] = docs
            end


            local values = {
                title = fields.name or fields.title,
                uuid = doc_id,
                store = store
            }
            if all_fields then
                for k,v in pairs(fields) do
                    values[k] = v
                end
            end
            table.insert(docs, values)

        end
    end)

    if count_pairs(subdocuments) == 0 then subdocuments = nil end

    return subdocuments
end