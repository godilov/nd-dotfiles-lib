local type_lib        = require 'nd.lib.core.type'
local assert_lib      = require 'nd.lib.core.assert'

local is_num          = type_lib.is_num
local is_tab          = type_lib.is_tab
local is_fn           = type_lib.is_fn

local nd_assert       = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err          = assert_lib.get_err_fn 'nd.lib.core.fn'

local next_fn         = next

local is_iter         = nil
local get_iter        = nil
local empty_next      = nil
local range_next      = nil
local iv_next         = nil
local kv_next         = nil
local keys_next       = nil
local get_map_iter    = nil
local get_filter_iter = nil
local get_reduce      = nil
local get_concat_iter = nil
local get_zip_iter    = nil
local get_take_iter   = nil
local get_skip_iter   = nil
local get_count       = nil
local get_all         = nil
local get_any         = nil
local get_add_iter    = nil
local get_remove_iter = nil
local get_collect     = nil
local get_each        = nil


local empty   = nil
local range   = nil
local it      = nil
local iv      = nil
local kv      = nil
local keys    = nil
local ivals   = nil
local kvals   = nil
local map     = nil
local filter  = nil
local reduce  = nil
local concat  = nil
local zip     = nil
local take    = nil
local skip    = nil
local count   = nil
local all     = nil
local any     = nil
local add     = nil
local remove  = nil
local collect = nil
local each    = nil
local pipe    = nil


local iter_mt = {
    __call = function(iter)
        return iter[1], iter[2], iter[3]
    end,
    __mul = function(x, fn)
        local is_x_iter = is_iter(x)
        local is_x_fn   = is_fn(x)

        nd_assert((is_x_iter or is_x_fn) and is_fn(fn), nd_err,
            'iter.mul(): x must be of type iter or function and fn must be of type function')

        return is_x_iter and fn(x) or function(iter_ext)
            return fn(x(iter_ext))
        end
    end,
}


is_iter = function(val)
    return getmetatable(val) == iter_mt
end

get_iter = function(next, data, state)
    nd_assert(is_fn(next), nd_err, 'get_iter(): next must be of type function')

    return setmetatable({ next, data, state }, iter_mt)
end

empty_next = function()
end

range_next = function(data, state)
    local stop = data[1]
    local step = data[2]
    local sign = data[3]

    local val = state[2] + step

    if sign * val < sign * stop then
        return { state[1] + 1, val }
    end
end

iv_next = function(data, state)
    local index = state[1] + 1
    local val   = data[index]

    if val then
        return { index, val }
    end
end

kv_next = function(data, state)
    local key, val = next_fn(data, state[1])

    if key then
        return { key, val }
    end
end

keys_next = function(data, state)
    return (next_fn(data, state))
end

empty = function()
    return get_iter(empty_next)
end

range = function(len, start, step)
    if not start then start = 1 end
    if not step then step = 1 end

    nd_assert(is_num(len), nd_err, 'range(): len must be of type number')
    nd_assert(is_num(start), nd_err, 'range(): start must be of type number')
    nd_assert(is_num(step), nd_err, 'range(): step must be of type number')
    nd_assert(step ~= 0, nd_err, 'range(): step must be non-zero')
    nd_assert(len >= 0, nd_err, 'range(): len must be more than zero or equal')

    local sign = step > 0 and 1 or -1
    local stop = start + sign * len

    return get_iter(range_next, { stop, step, sign }, { 0, start - step })
end

it = function(fn)
    nd_assert(is_fn(fn), nd_err, 'it(): t must be of type function')

    return get_iter(fn)
end

iv = function(t)
    nd_assert(is_tab(t), nd_err, 'iv(): t must be of type table')

    return get_iter(iv_next, t, { 0 })
end

kv = function(t)
    nd_assert(is_tab(t), nd_err, 'kv(): t must be of type table')

    return get_iter(kv_next, t, {})
end

keys = function(t)
    nd_assert(is_tab(t), nd_err, 'keys(): t must be of type table')

    return get_iter(keys_next, t, nil)
end

ivals = function(t)
    nd_assert(is_tab(t), nd_err, 'ivals(): t must be of type table')

    local index = 0

    return get_iter(function(data, _)
        index = index + 1

        local v = data[index]

        if v then
            return v
        end
    end, t, nil)
end

kvals = function(t)
    nd_assert(is_tab(t), nd_err, 'kvals(): t must be of type table')

    local key = nil

    return get_iter(function(data, _)
        local k, v = next_fn(data, key)

        key = k

        if v then
            return v
        end
    end, t, nil)
end

get_map_iter = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'get_map_iter(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'get_map_iter(): iter must be of type iter')

    local next = iter[1]

    return get_iter(function(data, state)
        local elem = next(data, state)

        return elem and fn(elem)
    end, iter[2], iter[3])
end

get_filter_iter = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'get_filter_iter(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'get_filter_iter(): iter must be of type iter')

    local next = iter[1]

    return get_iter(function(data, state)
        local elem = next(data, state)

        while elem and not fn(elem) do
            elem = next(data, elem)
        end

        return elem
    end, iter[2], iter[3])
end

get_reduce = function(fn, init, iter)
    nd_assert(is_fn(fn), nd_err, 'get_reduce(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'get_reduce(): iter must be of type iter')

    local val = init

    for elem in iter() do
        val = fn(val, elem)
    end

    return val
end

get_concat_iter = function(iter_, iter)
    nd_assert(is_iter(iter), nd_err, 'get_concat_iter(): iter must be of type iter')
    nd_assert(is_iter(iter_), nd_err, 'get_concat_iter(): iter_ must be of type iter')

    local next  = iter[1]
    local data  = iter[2]
    local elem  = iter[3]

    local next_ = iter_[1]
    local data_ = iter_[2]
    local elem_ = iter_[3]

    return get_iter(function(_, _)
        elem = next(data, elem)

        if elem then
            return elem
        end

        elem_ = next_(data_, elem_)

        if elem_ then
            return elem_
        end
    end, data, elem)
end

get_zip_iter = function(iter_, iter)
    nd_assert(is_iter(iter), nd_err, 'get_zip_iter(): iter must be of type iter')
    nd_assert(is_iter(iter_), nd_err, 'get_zip_iter(): iter_ must be of type iter')

    local next  = iter[1]
    local data  = iter[2]
    local elem  = iter[3]

    local next_ = iter_[1]
    local data_ = iter_[2]
    local elem_ = iter_[3]

    return get_iter(function(_, _)
        elem  = next(data, elem)
        elem_ = next_(data_, elem_)

        return elem and elem_ and { elem, elem_ }
    end, data, elem)
end

get_take_iter = function(n, iter)
    nd_assert(n > 0, nd_err, 'get_take_iter(): n must not be more than zero')
    nd_assert(is_iter(iter), nd_err, 'get_take_iter(): iter must be of type iter')

    local next  = iter[1]
    local index = 0

    return get_iter(function(data, state)
        if index < n then
            index = index + 1

            return next(data, state)
        end
    end, iter[2], iter[3])
end

get_skip_iter = function(n, iter)
    nd_assert(n > 0, nd_err, 'get_skip_iter(): n must not be more than zero')
    nd_assert(is_iter(iter), nd_err, 'get_skip_iter(): iter must be of type iter')

    local next  = iter[1]
    local index = n

    return get_iter(function(data, state)
        local elem = state

        for _ in range(index)() do
            elem = next(data, elem)
        end

        index = 0

        return next(data, elem)
    end, iter[2], iter[3])
end

get_count = function(iter)
    nd_assert(is_iter(iter), nd_err, 'get_count_iter(): iter must be of type iter')

    local index = 0

    for _ in iter() do
        index = index + 1
    end

    return index
end

get_all = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'get_all(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'get_all(): iter must be of type iter')

    for elem in iter() do
        if not fn(elem) then
            return false
        end
    end

    return true
end

get_any = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'get_any(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'get_any(): iter must be of type iter')

    for elem in iter() do
        if fn(elem) then
            return true
        end
    end

    return false
end

get_add_iter = function(val, index, iter)
    nd_assert(index > 0, nd_err, 'get_add_iter(): index must be greater than zero')
    nd_assert(is_iter(iter), nd_err, 'get_add_iter(): iter must be of type iter')

    local next = iter[1]
    local ind  = 0

    return get_iter(function(data, state)
        ind = ind + 1

        return ind == index and val or next(data, state)
    end, iter[2], iter[3])
end

get_remove_iter = function(index, iter)
    nd_assert(index > 0, nd_err, 'get_remove_iter(): index must be greater than zero')
    nd_assert(is_iter(iter), nd_err, 'get_remove_iter(): iter must be of type iter')

    local next = iter[1]
    local ind  = 0

    return get_iter(function(data, state)
        ind = ind + 1

        if ind == index then
            next(data, state)
        end

        return next(data, state)
    end, iter[2], iter[3])
end

get_collect = function(iter)
    nd_assert(is_iter(iter), nd_err, 'get_collect(): iter must be of type iter')

    local arr = {}
    local index = 0

    for x in iter() do
        index = index + 1

        arr[index] = x
    end

    return arr
end

get_each = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'get_each(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'get_each(): iter must be of type iter')

    for elem in iter() do
        fn(elem)
    end
end

map = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'map(): fn must be of type function')

    return iter and get_map_iter(fn, iter) or function(iter_ext)
        return get_map_iter(fn, iter_ext)
    end
end

filter = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'filter(): fn must be of type function')

    return iter and get_filter_iter(fn, iter) or function(iter_ext)
        return get_filter_iter(fn, iter_ext)
    end
end

reduce = function(fn, init, iter)
    nd_assert(is_fn(fn), nd_err, 'reduce(): fn must be of type function')

    return iter and get_reduce(fn, init, iter) or function(iter_ext)
        return get_reduce(fn, init, iter_ext)
    end
end

concat = function(iter_, iter)
    nd_assert(is_iter(iter_), nd_err, 'concat(): iter_ must be of type iter')

    return iter and get_concat_iter(iter_, iter) or function(iter_ext)
        return get_concat_iter(iter_, iter_ext)
    end
end

zip = function(iter_, iter)
    nd_assert(is_iter(iter_), nd_err, 'zip(): iter_ must be of type iter')

    return iter and get_zip_iter(iter_, iter) or function(iter_ext)
        return get_zip_iter(iter_, iter_ext)
    end
end

take = function(n, iter)
    nd_assert(n >= 0, nd_err, 'take(): n must not be non-negative')

    return iter and get_take_iter(n, iter) or function(iter_ext)
        return get_take_iter(n, iter_ext)
    end
end

skip = function(n, iter)
    nd_assert(n >= 0, nd_err, 'skip(): n must not be non-negative')

    return iter and get_skip_iter(n, iter) or function(iter_ext)
        return get_skip_iter(n, iter_ext)
    end
end

count = function(iter)
    return iter and get_count(iter) or function(iter_ext)
        return get_count(iter_ext)
    end
end

all = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'all(): fn must be of type function')

    return iter and get_all(fn, iter) or function(iter_ext)
        return get_all(fn, iter_ext)
    end
end

any = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'any(): fn must be of type function')

    return iter and get_any(fn, iter) or function(iter_ext)
        return get_any(fn, iter_ext)
    end
end

add = function(val, index, iter)
    nd_assert(index > 0, nd_err, 'add(): index must be greater than zero')

    return iter and get_add_iter(val, index, iter) or function(iter_ext)
        return get_add_iter(val, index, iter_ext)
    end
end

remove = function(index, iter)
    nd_assert(index > 0, nd_err, 'remove(): index must be greater than zero')

    return iter and get_remove_iter(index, iter) or function(iter_ext)
        return get_remove_iter(index, iter_ext)
    end
end

collect = function(iter)
    return iter and get_collect(iter) or function(iter_ext)
        return get_collect(iter_ext)
    end
end

each = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'each(): fn must be of type function')

    return iter and get_each(fn, iter) or function(iter_ext)
        return get_each(fn, iter_ext)
    end
end

pipe = function(iter, args)
    nd_assert(is_iter(iter), nd_err, 'pipe(): iter must be of type iter')
    nd_assert(is_tab(args), nd_err, 'pipe(): args must be of type table')

    return reduce(function(val, fn)
        return fn(val)
    end, iter, ivals(args))
end

return {
    empty   = empty,
    range   = range,
    it      = it,
    iv      = iv,
    kv      = kv,
    keys    = keys,
    ivals   = ivals,
    kvals   = kvals,
    map     = map,
    filter  = filter,
    reduce  = reduce,
    concat  = concat,
    zip     = zip,
    take    = take,
    skip    = skip,
    count   = count,
    all     = all,
    any     = any,
    add     = add,
    remove  = remove,
    collect = collect,
    each    = each,
    pipe    = pipe,
}
