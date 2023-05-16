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

local concat_arg      = nil
local concat          = nil
local merge_arg       = nil
local merge           = nil
local merge_deep      = nil
local clone           = nil
local clone_deep      = nil
local clone_with      = nil
local clone_deep_with = nil


self = function(x)
    return x
end

set_iv = function(i_fn, v_fn)
    local i = i_fn or self
    local v = v_fn or self

    return function(t, elem)
        t[i(#t + 1)] = v(elem)

        return t
    end
end

set_kv = function(k_fn, v_fn)
    return function(t, elem)
        t[k_fn(elem[1])] = v_fn(elem[2])

        return t
    end
end

concat_arg = function(t, arg)
    return reduce(set_iv(), t, ivals(arg))
end

merge_arg = function(t, arg)
    return reduce(set_kv(self, self), t, kv(arg))
end

concat = function(args)
    return reduce(concat_arg, {}, ivals(args))
end

merge = function(args)
    return reduce(merge_arg, {}, ivals(args))
end

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

clone = function(val)
    return is_tab(val) and
        reduce(set_kv(self, self), {}, kv(val)) or
        val
end

clone_deep = function(val)
    return is_tab(val) and
        reduce(set_kv(clone_deep, clone_deep), {}, kv(val)) or
        val
end

clone_with = function(val, t)
    return is_tab(val) and
        reduce(set_kv(self, self), clone(val), kv(t)) or
        t
end

clone_deep_with = function(val, t)
    return is_tab(val) and
        reduce(set_kv(self, self), clone_deep(val), kv(t)) or
        t
end

return {
    concat          = concat,
    merge           = merge,
    merge_deep      = merge_deep,
    clone           = clone,
    clone_deep      = clone_deep,
    clone_with      = clone_with,
    clone_deep_with = clone_deep_with,
}
