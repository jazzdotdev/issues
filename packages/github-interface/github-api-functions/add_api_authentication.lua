function github_api.add_api_authentication( url )
    -- Adding GitHub api authentication
    if settings.github_client_id then
        -- GitHub client id
        url = github_api.add_request_param(url,"client_id",settings.github_client_id)
    end
    if settings.github_client_secret then
        -- GitHub client secret
        url = github_api.add_request_param(url,"client_secret",settings.github_client_secret)
    end
    return url
end