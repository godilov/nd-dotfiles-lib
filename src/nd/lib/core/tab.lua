local fn_lib   = require 'nd.lib.core.fn'
local type_lib = require 'nd.lib.core.type'

local kv       = fn_lib.kv
local ivals    = fn_lib.ivals

local map      = fn_lib.map
local filter   = fn_lib.filter
local reduce   = fn_lib.reduce
local collect  = fn_lib.collect

local is_tab   = type_lib.is_tab


local self            = nil
local set_iv          = nil
local set_kv          = nil
local set_iv_self     = nil
local set_kv_self     = nil

local flat_arg        = nil
local concat_arg      = nil
local merge_arg       = nil
local flat            = nil
local concat          = nil
local merge           = nil
local merge_deep      = nil
local clone           = nil
local clone_deep      = nil
local clone_with      = nil
local clone_deep_with = nil


--- Returns itself
--- @param x any
--- @return any
self = function(x)
    return x
end

--- Returns closure which sets elem (index, value) to table and returns it
--- @param i_fn function
--- @param v_fn function
--- @return function
set_iv = function(i_fn, v_fn)
    return function(t, elem)
        t[i_fn(#t + 1)] = v_fn(elem)

        return t
    end
end

--- Returns closure which sets elem (key, value) to table and returns it
--- @param k_fn function
--- @param v_fn function
--- @return function
set_kv = function(k_fn, v_fn)
    return function(t, elem)
        t[k_fn(elem[1])] = v_fn(elem[2])

        return t
    end
end

set_iv_self = set_iv(self, self)
set_kv_self = set_kv(self, self)

--- Flatten an element into a resulting array
--- @param t table
--- @param arg table
--- @return table
flat_arg = function(t, arg)
    return is_tab(arg) and reduce(set_iv_self, t, ivals(arg)) or
        set_iv_self(t, arg)
end

--- Concatenates an element into a resulting array
--- @param t table
--- @param arg table
--- @return table
concat_arg = function(t, arg)
    return reduce(set_iv_self, t, ivals(arg))
end

--- Merges an element into a resulting table
--- @param t table
--- @param arg table
--- @return table
merge_arg = function(t, arg)
    return reduce(set_kv_self, t, kv(arg))
end

--- Flatten multiple arrays and values into a single arrays
--- @param args arr<any>
--- @return arr<any>
flat = function(args)
    return reduce(flat_arg, {}, ivals(args))
end

--- Concatenates multiple arrays into a single arrays
--- @param args arr<any>
--- @return arr<any>
concat = function(args)
    return reduce(concat_arg, {}, ivals(args))
end

--- Merges multiple tables into a single table
--- @param args arr<table>
--- @return table
merge = function(args)
    return reduce(merge_arg, {}, ivals(args))
end

--- Merges multiple tables into a single table with recursion
--- @param args arr<table>
--- @return table
merge_deep = function(args)
    return reduce(function(tx, arg)
        return is_tab(arg)
            and reduce(function(t, elem)
                local k = elem[1]

                if not t[k] then
                    t[k] = merge_deep(collect(
                        filter(function(x) return x ~= '' end,
                            map(function(x) return x[k] or '' end,
                                ivals(args)))))
                end

                return t
            end, tx or {}, kv(arg))
            or arg
    end, nil, ivals(args))
end

--- Clones argument (by value)
--- @param val any
--- @return any
clone = function(val)
    return is_tab(val) and
        reduce(set_kv_self, {}, kv(val)) or
        val
end

--- Clones argument (by value) with recursion for tables
--- @param val any
--- @return any
clone_deep = function(val)
    return is_tab(val) and
        reduce(set_kv(clone_deep, clone_deep), {}, kv(val)) or
        val
end

--- Clones argument (by value) and sets values of t
--- @param val any
--- @param t table
--- @return any
clone_with = function(val, t)
    return is_tab(val) and
        reduce(set_kv_self, clone(val), kv(t)) or
        t
end

--- Clones argument (by value) with recursion for tables and sets values of t
--- @param val any
--- @param t table
--- @return any
clone_deep_with = function(val, t)
    return is_tab(val) and
        reduce(set_kv_self, clone_deep(val), kv(t)) or
        t
end

return {
    flat            = flat,
    concat          = concat,
    merge           = merge,
    merge_deep      = merge_deep,
    clone           = clone,
    clone_deep      = clone_deep,
    clone_with      = clone_with,
    clone_deep_with = clone_deep_with,
}
