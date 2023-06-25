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


--- @alias key any
--- @alias index number
--- @alias value any

--- Table of key-type T and value-type V
--- @class tab<T, V>: { [T]: V }

--- Array of value-type V and length N
--- @class arr<V, N>: { [integer]: V }

--- Indexed value
--- @class ind<I, V>: { [1]: I, [2]: V }

--- Checks if val is not nul
--- @param val any
--- @return boolean
is_val = function(val)
    return val ~= nil
end

--- Checks if val is nul
--- @param val any
--- @return boolean
is_nil = function(val)
    return val == nil
end

--- Checks if val is of type boolean
--- @param val any
--- @return boolean
is_bool = function(val)
    return type(val) == 'boolean'
end

--- Checks if type is of type number
--- @param val any
--- @return boolean
is_num = function(val)
    return type(val) == 'number'
end

--- Checks if val is of type string
--- @param val any
--- @return boolean
is_str = function(val)
    return type(val) == 'string'
end

--- Checks if val is of type table
--- @param val any
--- @return boolean
is_tab = function(val)
    return type(val) == 'table'
end

--- Checks if val is of type function
--- @param val any
--- @return boolean
is_fn = function(val)
    return type(val) == 'function'
end

--- Checks if x and y of the same type
--- @param x any
--- @param y any
--- @return boolean
are_same = function(x, y)
    return type(x) == type(y)
end

--- Checks if x and y of the same type by metatable
--- @param x any
--- @param y any
--- @return boolean
are_same_mt = function(x, y)
    return getmetatable(x) == getmetatable(y)
end

--- Checks if x and y are equal by value
--- @param x any
--- @param y any
--- @return boolean
are_eq = function(x, y)
    if x ~= y and (is_nil(x) or is_nil(y)) then
        return false
    end

    assert(are_same(x, y), 'nd.lib.core.type.are_eq(): x and y must be of same type')

    if x == y then
        return true
    elseif not is_tab(x) and #x ~= #y then
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
