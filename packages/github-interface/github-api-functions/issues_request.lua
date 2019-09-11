function github_api.issues_request(query, search_keyword, type)

    local table_filters_format = {
        title = "\"~\"in:title",
        body = "\"~\"in:body",
        comments = "\"~\"in:comments",
        label = "label:\"~\"",
    }

    -- local request_settings = {
    --     github_api_url = "https://api.github.com/search/issues",
    --     api_query = "q"
    -- }

    local github_filters, summary_fields_values = github_api.table_to_gitfilters(query, table_filters_format)

    log.debug( "Summary fields: " .. json.from_table(summary_fields_values))
    -- GitHub api Url
    local url = "https://api.github.com/search/issues?q={ type:".. type .." ".. github_filters .." " .. search_keyword .. " }"

    log.debug('Executing request to: ' .. url)

    url = github_api.add_api_authentication(url) --adding github app auth if it was added in the lighttouch.scl

    local github_response = send_request(url) --get request to the api

    local issues = github_response.body.items

    return issues, summary_fields_values
end

