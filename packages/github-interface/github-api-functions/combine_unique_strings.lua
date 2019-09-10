function github_api.combine_unique_strings(main_s, added_s )
    -- check to add a unique string into another string
    if string.find( main_s, added_s, 1) then
        -- the added_s already belongs to the main_s
        return main_s
    end
    return main_s .. added_s
end