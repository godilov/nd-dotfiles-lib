--- Clamps a value in range of min and max
--- @param val number
--- @param min_val number
--- @param max_val number
local clamp = function(val, min_val, max_val)
    return val < min_val and min_val
        or val > max_val and max_val
        or val
end

return {
    clamp = clamp,
}
