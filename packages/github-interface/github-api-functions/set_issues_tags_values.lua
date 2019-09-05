function github_api.set_issues_tags_values(issues_tags, name, value)
    if issues_tags[name] == nil then
        issues_tags[name] = {} --all the custom fields names are in variable to show them in columns
    end
    -- if the values storage is nil create it
    if issues_tags[name]['values'] == nil then
        issues_tags[name]['values'] = {}
    end
    -- for each name store the name
    issues_tags[name]['name'] = name
    -- for each name store all possible values
    issues_tags[name]['values'][value] = {}
    issues_tags[name]['values'][value]['value'] = value
    issues_tags[name]['values'][value]['is_checked'] = false

    return issues_tags
end