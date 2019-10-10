function documents_model.group_docs_table_fields(
    doc_array,
    field_table_name,
    filters
)
    -- considering that a document in the doc array has field_table_name
    -- and filters is an array of key tables
    -- which is an array of key tables
    -- this will return all documents that have
    -- in the elements of field_table_name the values of filters


    local result = {}
    local valid

    for _,doc in pairs(doc_array) do
        -- for all documents
        valid = true
        local documents = doc[field_table_name]
        if documents and next(documents) ~= nil then
            for _k,value in pairs(documents) do
                -- for all elements in the field array
                for __k,filter in pairs(filters) do
                    -- for each filter table
                    for k,v in pairs(filter) do

                        if value[k] ~= v then

                            valid = false

                        else

                            log.debug('key')
                            log.debug(k)
                            log.debug('value f')
                            log.debug(v)
                            log.debug('value tag')
                            log.debug(value[k])

                        end
                    end

                end
            end
        else
            valid = false
        end
        if valid then
            log.debug(json.from_table(doc))
            table.insert(result, doc)
        end

    end


    return result


end