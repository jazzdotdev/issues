function documents_model.filter_doc_by_m2m(
    parent_model_name,
    m2m_model_name,
    child_model_name,
    child_filters
)
    local result = {}
    local docs
    local m2m_docs = {}

    local m2m_filter = {}

    -- all documents that belong to the filter
    docs = documents_model.list_documents(
        child_model_name,
        child_filters,
        false,
        true
    ).documents
    for j,value in ipairs(docs) do
        -- the filter is the uuid of the filtered model
        m2m_filter[child_model_name] = value.uuid

        -- all documents from the m2m model that combine the filter with other document
        m2m_documents = documents_model.list_documents(
            m2m_model_name,
            m2m_filter,
            false,
            true
        ).documents

        -- for all the many to many documents
        for k,doc in ipairs(m2m_documents) do
            -- build a list of all the documents that connect
            m2m_docs[doc.uuid] = doc
        end

    end

    for k,val in pairs(m2m_docs) do
        local fields, body, store = contentdb.read_document(val[parent_model_name])
        fields['uuid'] = val[parent_model_name]
        fields['__body__'] = body
        fields['__store__'] = store

        result[fields.uuid] = fields
    end

    return result
end