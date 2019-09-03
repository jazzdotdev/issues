-- stops a string to have repeated patterns
-- to avoid having multiple of the same filter
-- if the pattern is not in the main string it is added
function github_api.check_repeated(main_s, added_s )
    if string.find( main_s, added_s, 1) then
        -- the added_s already belongs to the main_s
        return main_s
    end
    return main_s .. added_s
end