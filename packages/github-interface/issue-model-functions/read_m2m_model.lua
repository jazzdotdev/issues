function documents_model.read_m2m_model(parent_uuid, parent_model_name, conector_model_name, child_model_name)
    -- returns all the models that belog to a model
    -- using a many to many relation that uses a conector model
    local result = {}

    local subdocuments = documents_model.list_subdocuments(parent_model_name, parent_uuid, true)
    if subdocuments[conector_model_name] then
        for _,doc in pairs(subdocuments[conector_model_name]) do
            local fields, body, store = contentdb.read_document(doc[child_model_name])
            fields['body'] = body
            fields['store'] = store
    
            table.insert(result, fields)
        end
    end

    return result
end