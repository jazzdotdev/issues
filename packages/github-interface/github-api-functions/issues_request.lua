function github_api.issues_request(query, search_kewyword, type)

    local github_filters, summary_fields_values = github_api.create_filters(query)
    -- GitHub api Url
    local url = "https://api.github.com/search/issues?q={ type:".. type .." ".. github_filters .." " .. search_kewyword .. " }"
    url = github_api.add_api_authentication(url) --adding github app auth if it was added in the lighttouch.scl

    local github_response = send_request(url) --get request to the api

    local issues = github_response.body.items

    return issues, summary_fields_values
end