function github_api.set_selected_filters(query, issues_tags)
    -- Sets a centinel value to show the selected values
    -- in checkboxes of the frontend

    for k,v in pairs(query.query) do -- for each query parameter
        if string.find(k,"selection") then -- if the parameter has the word selection
            local name, value = v:match("^(.+):(.+)$") -- name and value of the selection
            -- especial check for empty values
            if issues_tags[name] == nil then
                issues_tags[name] = {}
                issues_tags[name]['name'] = name
                issues_tags[name]['values'] = {}
                issues_tags[name]['values'][value] = {}
            end

            if issues_tags[name]['values'][value] == nil then
                issues_tags[name]['values'][value] = {}
            end

            if issues_tags[name]['values'][value]['value'] == nil  then
                issues_tags[name]['values'][value]['value'] = value
            end
            -- end special check for empty values

            --average check for values
            -- if the value exists it is already selected
            if issues_tags[name]['values'][value]['value'] then
                issues_tags[name]['has_checked'] = true
                issues_tags[name]['values'][value]['is_checked'] = true
            end
        end
    end

    return issues_tags
end