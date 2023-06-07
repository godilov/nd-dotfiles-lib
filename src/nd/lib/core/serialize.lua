local fn_lib     = require 'nd.lib.core.fn'
local str_lib    = require 'nd.lib.core.str'
local type_lib   = require 'nd.lib.core.type'
local assert_lib = require 'nd.lib.core.assert'

local kv         = fn_lib.kv
local map        = fn_lib.map
local collect    = fn_lib.collect

local concat2s   = str_lib.concat2s
local concat3s   = str_lib.concat3s

local is_bool    = type_lib.is_bool
local is_num     = type_lib.is_num
local is_str     = type_lib.is_str
local is_tab     = type_lib.is_tab

local nd_assert  = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err     = assert_lib.get_err_fn 'nd.lib.core.serialize'

local format     = string.format
local match      = string.match
local gsub       = string.gsub

local concat     = table.concat

local loadstring = loadstring or load
local tostring   = tostring


local as_str = nil
local as_val = nil


--- @class serialize_options
--- @field sep string
--- @field step string
--- @field offset string

--- Returns serialialize into a string value
--- Returns as correct Lua code
--- @param val any
--- @param options? serialize_options
--- @return string|nil
as_str = function(val, options)
    if is_bool(val) or is_num(val) then
        return tostring(val)
    elseif is_str(val) then
        return format('\'%s\'', gsub(val, '\n', ' <-- New Line --> '))
    end

    if not is_tab(val) then
        return nil
    end

    local opts_       = options or {}

    local sep         = opts_.sep or '\n'
    local step        = opts_.step or '    '
    local offset      = opts_.offset or ''
    local offset_next = concat2s(offset, step)

    local opts        = {
        sep    = sep,
        step   = step,
        offset = offset_next,
    }


    local arr = collect(map(function(elem)
        local k = elem[1]
        local v = elem[2]

        local str = as_str(v, opts)

        return is_num(k) and k <= #val and concat3s(offset_next, str or 'nil', ',') or
            format('%s[\'%s\'] = %s,', offset_next, k, str or 'nil')
    end, kv(val)))

    return format('{%s%s%s%s}', sep, concat(arr, sep), sep, offset)
end

--- Returns deserialized int a value string
--- @param str string
--- @return any
as_val = function(str)
    nd_assert(is_str(str), nd_err, 'as_val(): str must be of type string')

    if str == '' or str == 'nil' then
        return nil
    end

    return nd_assert(loadstring(match(str, '^[\n\t%s]*return') and str or format('return %s', str)), nd_err,
        'as_val(): loadstring returned nil')()
end

return {
    as_str = as_str,
    as_val = as_val,
}
