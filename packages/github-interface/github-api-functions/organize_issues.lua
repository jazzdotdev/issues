function github_api.organize_issues(issues, issues_tags)
    -- for each issue
    for _, issue in ipairs(issues) do
        -- set minified body
        issue.min_body = string.sub(issue.body,0,150)
        -- tags of the issues
        issue.tags = {}
        for _, label in ipairs(issue.labels) do
            local name, value = label.name:match("^(.+)/(.+)$")
            if name then
                -- each name "issue, value, size, etc.."
                issue.tags[name] = value

                -- saving all the tags from different issues
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
            end
        end

        -- Setting comments of the issues
        issue.el_comments = {}
        if issue.comments > 0 then
            local comment_response = send_request(github_api.add_api_authentication(issue.comments_url)) --get request to the comments
            local comments = comment_response.body
            for _,comment in ipairs(comments) do
                table.insert(issue.el_comments,{
                    author = comment.user.login,
                    body = comment.body
                })
            end
        end -- end Issue comments

        -- Issue id number
        issue.number_id = send_request(github_api.add_api_authentication(issue.url)).body.number
    end

    return issues, issues_tags
end