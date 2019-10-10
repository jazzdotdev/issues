function documents_model.filter_m2m_doc(
    parent_model_name,
    m2m_model_name,
    child_model_name,
    child_filters
)
    local result = {}

    local child_docs = documents_model.list_documents(
        child_model_name,
        child_filters,
        true,
        true
    )

    local m2m_docs = {}


    return result
end