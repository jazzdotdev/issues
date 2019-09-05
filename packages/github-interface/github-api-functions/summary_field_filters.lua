function github_api.summary_field_filters( title, body, comments)
    -- Setting values fot the fields of the column summary
    local fields_table = {
        title = {
            name = 'title',
        },
        body =  {
            name = 'body',
        },
        comments = {
            name = 'comments',
        },
    }

    local filters = ""

    if title then
        filters = filters .. ',title:' .. title
        fields_table['title']['value'] = title
    end

    if body then
        filters = filters .. ',body:' .. body
        fields_table['body']['value'] = body
    end

    if comments then
        filters = filters .. ',comments:' .. comments
        fields_table['comments']['value'] = comments
    end

    return filters, fields_table
end