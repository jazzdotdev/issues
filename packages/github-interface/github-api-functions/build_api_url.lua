function github_api.build_api_url( url_params_format, url_params, filters, delimiter)
    local BASE_URL = "https://api.github.com/search/issues?q={~}"

    local final_url = string.gsub(BASE_URL,delimiter,filters .. " ~")
    local params_word = ""
    for k,val in pairs(url_params_format) do
        if url_params[k] then
            url_params_format[k] = string.gsub(
                val,
                delimiter,
                url_params[k]
            )
            params_word = params_word .. " " .. url_params_format[k]
        end
    end

    final_url = string.gsub(final_url,delimiter,params_word)
    final_url = github_api.add_api_authentication(final_url)

    return final_url
end