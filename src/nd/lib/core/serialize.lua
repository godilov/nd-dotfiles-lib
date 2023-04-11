local type_lib   = require 'nd.lib.core.type'
local assert_lib = require 'nd.lib.core.assert'

local is_bool    = type_lib.is_bool
local is_num     = type_lib.is_num
local is_str     = type_lib.is_str
local is_tab     = type_lib.is_tab

local nd_assert  = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err     = assert_lib.get_err_fn 'nd.lib.core.serialize'

local format     = string.format

local concat     = table.concat

local loadstring = loadstring
local tostring   = tostring
local pairs      = pairs


local as_str = nil
local as_val = nil


as_str = function(val, options)
    if is_bool(val) or is_num(val) then
        return tostring(val)
    elseif is_str(val) then
        return format('\'%s\'', val)
    end

    if not is_tab(val) then
        return nil
    end

    local opts        = options or {}

    local sep         = opts.sep or '\n'
    local step        = opts.step or '    '
    local offset      = opts.offset or ''
    local offset_next = format('%s%s', offset, step)

    local opts_next   = {
        sep    = sep,
        step   = step,
        offset = offset_next,
    }

    local arr         = {}
    local index       = 0

    for _, v in ipairs(val) do
        local str = as_str(v, opts_next)

        index = index + 1

        arr[index] = format('%s%s,', offset_next, str or 'nil')
    end

    for k, v in pairs(val) do
        if not arr[k] then
            local str = as_str(v, opts_next)

            if str then
                index = index + 1

                arr[index] = format('%s[\'%s\'] = %s,', offset_next, k, str or 'nil')
            end
        end
    end

    return format('{%s%s%s%s}', sep, concat(arr, sep), sep, offset)
end

as_val = function(str)
    nd_assert(is_str(str), nd_err, 'as_val(): str must be of type string')

    if str == '' or str == 'nil' then
        return nil
    end

    return nd_assert(loadstring(format('return %s', str)), nd_err,
        'as_val(): loadstring returned nil')()
end

return {
    as_str = as_str,
    as_val = as_val,
}
