function github_api.organize_issues(issues, issues_tags)
    -- for each issue
    for _, issue in ipairs(issues) do
        -- set minified body
        issue.min_body = string.sub(issue.body,0,150)

        -- setting tags of the issues
        -- issue, issues_tags = github_api.labels_to_tags(issue, issues_tags )

        -- tags of the issues
        issue.tags = {}
        for _, label in ipairs(issue.labels) do
            local name, value = label.name:match("^(.+)/(.+)$")
            if name then
                -- each name "issue, value, size, etc.."
                issue.tags[name] = value
                issues_tags = github_api.set_issues_tags_values(issues_tags, name, value)
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