local set   = nil
local get   = nil

local cache = {}


set = function(key, val)
    cache[key] = val
end

get = function(key)
    return cache[key]
end

return {
    set = set,
    get = get,
}
