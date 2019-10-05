function documents_model.build_mapped_filters(filters,filter_map,query)

    for k,v in pairs(filters) do
        -- if the filter key exist in the filter map
        if filter_map[k] then
            -- read the query that matches based in the filter map
            if query[filter_map[k]] ~= "" then
                -- if the query value is not an empty string use it for the filter
                filters[k] = query[filter_map[k]]
            end
        end
    end

    return filters
end

