function documents_model.list_documents(model_name,filters)

    local uuids = {}

    contentdb.walk_documents(nil,
        function (file_uuid, fields, body, store)
            if fields.model ~= model_name then return end

            -- Filter the documents using the query params
            for k, v in pairs(filters) do
                if fields[k] ~= v then
                    -- Don't add this document to the list
                    return
                end
            end
            table.insert(uuids, {
                name = fields.name or fields.title,
                uuid = file_uuid,
                store = store
            })
        end
    )

    return {documents=uuids}
end
