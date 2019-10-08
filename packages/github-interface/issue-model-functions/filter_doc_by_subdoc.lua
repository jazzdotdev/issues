function documents_model.filter_doc_by_subdoc(submodel_name, main_model_name, submodel_filters, lazy_filter)
    -- returns a dictionary table having for key the document uuid
    local subdocuments = documents_model.list_documents(submodel_name, submodel_filters, lazy_filter, true)

    local documents = {}

    for _,val in pairs(subdocuments.documents) do
        local fields, body, store = contentdb.read_document(val[main_model_name])
        fields['uuid'] = val[main_model_name]
        fields['__body__'] = body
        fields['__store__'] = store
        documents[val[main_model_name]] = fields
    end

    return documents
end