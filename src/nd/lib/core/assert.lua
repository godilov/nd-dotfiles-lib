local type_lib = require 'nd.lib.core.type'

local is_nil   = type_lib.is_nil
local is_str   = type_lib.is_str
local is_fn    = type_lib.is_fn

local format   = string.format


local get_message     = nil
local assert_fn       = nil
local assert_fn_empty = nil
local get_fn          = nil
local get_err_fn      = nil


--- Returns a message of error
--- @param err function|string|nil
--- @param args any
get_message = function(err, args)
    assert(is_fn(err) or is_str(err) or is_nil(err),
        'nd.lib.core.assert.get_message(): err must be of type nil, string or function')

    --- @cast err function
    return is_fn(err) and err(args)
        or is_str(err) and err
        or is_nil(err) and 'assertion failed!'
end

--- Calls error() if val is not true
--- @param val any
--- @param err function|string|nil
--- @param args any
--- @raise
--- @return any
assert_fn = function(val, err, args)
    if not val then
        error(get_message(err, args))
    end

    return val
end

--- Calls nothing
--- @param val any
--- @return any
assert_fn_empty = function(val)
    return val
end

--- Returns implementation for assert function
--- @param is_debug boolean
--- @return function
get_fn = function(is_debug)
    return is_debug and assert_fn or assert_fn_empty
end

--- Returns error-handling function
--- @param scope string
--- @return function
get_err_fn = function(scope)
    return function(message)
        assert(is_str(scope), 'nd.lib.core.assert.get_err_fn(): scope must be of type string')
        assert(is_str(message), 'nd.lib.core.assert.get_err_fn(): message must be of type string')

        return format('%s.%s', scope, message)
    end
end

return {
    get_fn     = get_fn,
    get_err_fn = get_err_fn,
}
