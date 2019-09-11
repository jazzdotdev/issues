function github_api.tag_to_label(tag)
    local name, value = tag:match("^(.+):(.+)$")
    if name then
        return name .. "/".. value
    end
    return nil
end