function github_api.issues_request(query, search_keyword, type)
    local delimiter = "~"
    -- the character ~ will be replased with the correspongin value
    local table_filters_format = {
        title = "\"~\"in:title",
        body = "\"~\"in:body",
        comments = "\"~\"in:comments",
        label = "label:\"~\"",
    }

    local github_filters, summary_fields = github_api.table_to_gitfilters(
        query, -- query of data
        table_filters_format, -- filer format
        delimiter -- flag within the filter format
    )
    local url_params= {
        type = type,
        keyword = search_keyword
    }
    local url_params_format = {
        type = "type:~", -- issue or pr
        keyword = "~",
    }

    -- GitHub api Url
    local url = github_api.build_api_url(
        url_params_format,
        url_params,
        github_filters,
        delimiter
    )

    log.debug('Executing request to: ' .. url)

    local github_response = send_request(url) --get request to the api

    local issues = github_response.body.items

    return issues, summary_fields
end

