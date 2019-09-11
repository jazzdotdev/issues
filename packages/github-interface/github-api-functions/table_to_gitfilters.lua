function github_api.table_to_gitfilters(query, table_filters_format)
    local gitfilter = ""
    local marker = "~"
    local filter_val, filters_values = github_api.values_to_filter_table(query, table_filters_format)
    -- local filter_val = {
    --     {
    --         title = "title awesome"
    --     },
    --     {
    --         body = "body example"
    --     },
    --     {
    --         label = "label/label"
    --     },
    --     {
    --         label = "hey/lol"
    --     },
    --     {
    --         comments = "comments 3"
    --     }
    -- }

    for _,value in ipairs(filter_val) do
        for k,val in pairs(value) do
            if table_filters_format[k] then
                local s = string.gsub(table_filters_format[k],marker,val)
                gitfilter = gitfilter .. " " .. s
            end
        end
    end

    return gitfilter, filters_values
end