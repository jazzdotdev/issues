function documents_model.build_tags(tag_filters,query)

    local tags = documents_model.group_documents(
        'tag', --
        'name', --
        'value', --
        'values', --
        tag_filters, --
        true --
    )
    tags = github_api.set_selected_filters(query, tags)

    -- log.debug(json.from_table(tags))
    
    local chosen_tags = {}
    for key,val in pairs(tags) do
        if val.has_checked then
            for _,v in pairs(val.values) do
                if v.is_checked then
                    table.insert(chosen_tags,{
                        name=val.name,
                        value=v.value
                    })
                end
            end
        end
    end
    
    -- log.debug(json.from_table(chosen_tags))


    tags = github_api.table_to_matrix(
        tags,
        3,
        function(a, b) return a.name < b.name end
    )
    return tags
end