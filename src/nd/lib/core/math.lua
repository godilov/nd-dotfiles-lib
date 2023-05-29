local clamp = function(val, min_val, max_val)
    return val < min_val and min_val
        or val > max_val and max_val
        or val
end

return {
    clamp = clamp,
}
