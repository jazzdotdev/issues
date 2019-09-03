-- Method to add client secret and client id 
-- for request authentication of the github api
function github_api.add_api_authentication( param_url )
    --adding client id to the request url
    if settings.github_client_id then
        param_url = github_api.add_request_param(param_url,"client_id",settings.github_client_id)
    end
    --adding client secret to the request url
    if settings.github_client_secret then
        param_url = github_api.add_request_param(param_url,"client_secret",settings.github_client_secret)
    end
    return param_url
end