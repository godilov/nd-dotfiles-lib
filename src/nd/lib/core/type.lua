local pairs = pairs
local type  = type


local is_val      = nil
local is_nil      = nil
local is_bool     = nil
local is_num      = nil
local is_str      = nil
local is_tab      = nil
local is_fn       = nil
local are_same    = nil
local are_same_mt = nil
local are_eq      = nil


is_val = function(val)
    return val ~= nil
end

is_nil = function(val)
    return val == nil
end

is_bool = function(val)
    return type(val) == 'boolean'
end

is_num = function(val)
    return type(val) == 'number'
end

is_str = function(val)
    return type(val) == 'string'
end

is_tab = function(val)
    return type(val) == 'table'
end

is_fn = function(val)
    return type(val) == 'function'
end

are_same = function(x, y)
    return type(x) == type(y)
end

are_same_mt = function(x, y)
    return getmetatable(x) == getmetatable(y)
end

are_eq = function(x, y)
    if x ~= y and (not x or not y) then
        return false
    end

    assert(are_same(x, y), 'nd.lib.core.type.are_eq(): x and y must be of same type')

    if x == y then
        return true
    elseif not is_tab(x) or #x ~= #y then
        return false
    end

    local keys = {}

    for xk, xv in pairs(x) do
        if not are_eq(xv, y[xk]) then
            return false
        end

        keys[xk] = true
    end

    for yk, _ in pairs(y) do
        if not keys[yk] then
            return false
        end
    end

    return true
end

return {
    is_val      = is_val,
    is_nil      = is_nil,
    is_bool     = is_bool,
    is_num      = is_num,
    is_str      = is_str,
    is_tab      = is_tab,
    is_fn       = is_fn,
    are_same    = are_same,
    are_same_mt = are_same_mt,
    are_eq      = are_eq,
}
