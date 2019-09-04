function github_api.execute_issues_petition(query)
    local github_filters, summary_fields_values = github_api.create_filters(query)

    local url = "https://api.github.com/search/issues?q={ type:issue ".. github_filters .." lighttouch }"
    url = github_api.add_api_authentication(url) --adding github app auth if it was added in the lighttouch.scl

    local github_response = send_request(url) --get request to the api

    local issues = github_response.body.items

    return issues, summary_fields_values
end