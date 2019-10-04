function documents_model.filter_doc_by_subdoc()
    comments_test = documents_model.list_documents('comment', {body="lorem"}, true, true)

    -- log.debug(json.from_table(
    --     comments_test.documents
    -- ))
    local count = 0
    for _ in pairs(comments_test.documents) do count = count + 1 end
    log.debug(count)

    local fields, body, store = contentdb.read_document(comments_test.documents[1].issue)
    -- log.debug(json.from_table(
    --     comments_test.documents[1]
    -- ))

    log.debug(
        json.from_table(fields)
    )
    log.debug(
        body
    )
    log.debug(
        store
    )
end