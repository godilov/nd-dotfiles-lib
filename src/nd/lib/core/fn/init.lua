local type_lib      = require 'nd.lib.core.type'
local assert_lib    = require 'nd.lib.core.assert'

local is_num        = type_lib.is_num
local is_tab        = type_lib.is_tab
local is_fn         = type_lib.is_fn

local nd_assert     = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err        = assert_lib.get_err_fn 'nd.lib.core.fn'

local next_fn       = next

local is_iter       = nil
local as_iter       = nil
local empty_next    = nil
local range_v_next  = nil
local range_iv_next = nil
local iv_next       = nil
local kv_next       = nil
local keys_next     = nil
local mapi_fn       = nil
local mapk_fn       = nil
local self          = nil

local empty         = nil
local range_v       = nil
local range_iv      = nil
local it            = nil
local iv            = nil
local kv            = nil
local keys          = nil
local ivals         = nil
local kvals         = nil
local mapi          = nil
local mapk          = nil

local map           = nil
local filter        = nil
local reduce        = nil
local concat        = nil
local zip           = nil
local take          = nil
local skip          = nil
local distinct      = nil
local group         = nil
local count         = nil
local all           = nil
local any           = nil
local add           = nil
local remove        = nil
local collect       = nil
local each          = nil
local pipe          = nil


--- @class iterator
--- @operator call(iterator): function
--- @operator mul(function): function

local iter_mt = {
    __call = function(iter)
        return iter[1], iter[2], iter[3]
    end,
    __mul = function(x, fn)
        local is_x_iter = is_iter(x)
        local is_x_fn   = is_fn(x)

        nd_assert((is_x_iter or is_x_fn) and is_fn(fn), nd_err,
            'iter.mul(): x must be of type iter or function and fn must be of type function')

        return is_x_iter and fn(x) or is_x_fn and function(iter_ext)
            return fn(x(iter_ext))
        end
    end,
}

--- Checks if val is of type iterator
--- @param val any
--- @return boolean
is_iter = function(val)
    return getmetatable(val) == iter_mt
end

--- Returns iterator
--- @param next function
--- @param data any
--- @param state any
--- @return iterator
as_iter = function(next, data, state)
    nd_assert(is_fn(next), nd_err, 'get_iter(): next must be of type function')

    return setmetatable({ next, data, state }, iter_mt)
end

--- Next function for empty iterator
--- @return nil
empty_next = function()
end

--- @alias range_v_data arr<number, 3>
--- @alias range_v_state number
--- @alias range_v_return range_v_state|nil
--- Next function for range by (value) iterator
--- @param data range_v_data
--- @param state range_v_state
--- @return range_v_return
range_v_next = function(data, state)
    local stop = data[1]
    local step = data[2]
    local sign = data[3]

    local val = state + step

    if sign * val < sign * stop then
        return val
    end
end

--- @alias range_iv_data arr<number, 3>
--- @alias range_iv_state arr<number, 2>
--- @alias range_iv_return range_iv_state|nil
--- Next function for range by (index, value) iterator
--- @param data range_iv_data
--- @param state range_iv_state
--- @return range_iv_return
range_iv_next = function(data, state)
    local len   = data[1]
    local step  = data[2]

    local index = state[1]
    local val   = state[2] + step

    if index < len then
        return { index + 1, val }
    end
end

--- @alias iv_next_data arr<value>
--- @alias iv_next_state ind<index, value>
--- @alias iv_next_return iv_next_state|nil
--- Next function for iterator over (index, value)
--- @param data iv_next_data
--- @param state iv_next_state
--- @return iv_next_return
iv_next = function(data, state)
    local index = state[1] + 1
    local val   = data[index]

    if val then
        return { index, val }
    end
end

--- @alias kv_next_data table
--- @alias kv_next_state ind<key, value>
--- @alias kv_next_return kv_next_state|nil
--- Next function for iterator over (key, value)
--- @param data kv_next_data
--- @param state kv_next_state
--- @return kv_next_return
kv_next = function(data, state)
    local key, val = next_fn(data, state[1])

    if key then
        return { key, val }
    end
end

--- @alias keys_next_data table
--- @alias keys_next_state key
--- @alias keys_next_return keys_next_state|nil
--- Next function for iterator over (key)
--- @param data keys_next_data
--- @param state keys_next_state
--- @return keys_next_return
keys_next = function(data, state)
    return (next_fn(data, state))
end

--- Map i-th elemnts
--- @param i index
--- @return function
mapi_fn = function(i)
    nd_assert(is_num(i), nd_err, 'get_mapi_fn(): i must be of type number')

    return function(elem)
        return elem[i]
    end
end

--- Map k-th elemnts
--- @param k key
--- @return function
mapk_fn = function(k)
    return function(elem)
        return elem[k]
    end
end

--- Returns arg
--- @param val any
--- @return any
self = function(val)
    return val
end

--- Empty iterator
--- @return iterator
empty = function()
    return as_iter(empty_next)
end

--- Range by (value) iterator
--- @param len number
--- @param start? number
--- @param step? number
--- @return iterator
range_v = function(len, start, step)
    if not start then start = 1 end
    if not step then step = 1 end

    nd_assert(is_num(len), nd_err, 'range_v(): len must be of type number')
    nd_assert(is_num(start), nd_err, 'range_v(): start must be of type number')
    nd_assert(is_num(step), nd_err, 'range_v(): step must be of type number')
    nd_assert(step ~= 0, nd_err, 'range_v(): step must be non-zero')
    nd_assert(len >= 0, nd_err, 'range_v(): len must be non-negative')

    local sign = step > 0 and 1 or -1
    local stop = start + step * len

    return as_iter(range_v_next, { stop, step, sign }, start - step)
end

--- Range by (index, value) iterator
--- @param len number
--- @param start? number
--- @param step? number
--- @return iterator
range_iv = function(len, start, step)
    if not start then start = 1 end
    if not step then step = 1 end

    nd_assert(is_num(len), nd_err, 'range_iv(): len must be of type number')
    nd_assert(is_num(start), nd_err, 'range_iv(): start must be of type number')
    nd_assert(is_num(step), nd_err, 'range_iv(): step must be of type number')
    nd_assert(step ~= 0, nd_err, 'range_iv(): step must be non-zero')
    nd_assert(len >= 0, nd_err, 'range_iv(): len must be non-negative')

    return as_iter(range_iv_next, { len, step }, { 0, start - step })
end

--- Iterator over a standard Lua function (pairs, ipairs, gmatch, ...)
--- @param fn function
--- @return iterator
it = function(fn)
    nd_assert(is_fn(fn), nd_err, 'it(): fn must be of type function')

    return as_iter(fn)
end

--- (index, value) iterator over an array
--- @param t arr<any>
--- @return iterator
iv = function(t)
    nd_assert(is_tab(t), nd_err, 'iv(): t must be of type table')

    return as_iter(iv_next, t, { 0 })
end

--- (key, value) iterator over a table
--- @param t table
--- @return iterator
kv = function(t)
    nd_assert(is_tab(t), nd_err, 'kv(): t must be of type table')

    return as_iter(kv_next, t, {})
end

--- (key) iterator over a table
--- @param t table
--- @return iterator
keys = function(t)
    nd_assert(is_tab(t), nd_err, 'keys(): t must be of type table')

    return as_iter(keys_next, t, nil)
end

--- (value) iterator over an array
--- @param t arr<any>
--- @return iterator
ivals = function(t)
    nd_assert(is_tab(t), nd_err, 'ivals(): t must be of type table')

    local index = 0

    return as_iter(function(data, _)
        index = index + 1

        local v = data[index]

        if v then
            return v
        end
    end, t, nil)
end

--- (key) iterator over a table
--- @param t table
--- @return iterator
kvals = function(t)
    nd_assert(is_tab(t), nd_err, 'kvals(): t must be of type table')

    local key = nil

    return as_iter(function(data, _)
        local k, v = next_fn(data, key)

        key = k

        if v then
            return v
        end
    end, t, nil)
end

--- Maps each element by index
--- @param i index
--- @param iter iterator
--- @return iterator
mapi = function(i, iter)
    nd_assert(is_num(i), nd_err, 'mapi(): i must be of type number')
    nd_assert(is_iter(iter), nd_err, 'mapi(): iter must be of type iterator')

    return map(mapi_fn(i), iter)
end

--- Maps each element by key
--- @param k key
--- @param iter iterator
--- @return iterator
mapk = function(k, iter)
    nd_assert(k, nd_err, 'mapk(): k must be of type value')
    nd_assert(is_iter(iter), nd_err, 'mapk(): iter must be of type iterator')

    return map(mapk_fn(k), iter)
end

--- Maps each element by function
--- @param fn function
--- @param iter iterator
--- @return iterator
map = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'map(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'map(): iter must be of type iterator')

    local next = iter[1]
    local data = iter[2]
    local elem = iter[3]

    return as_iter(function(_, _)
        elem = next(data, elem)

        return elem and fn(elem)
    end, data, elem)
end

--- Filters each element by function
--- @param fn function
--- @param iter iterator
--- @return iterator
filter = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'filter(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'filter(): iter must be of type iterator')

    local next = iter[1]
    local data = iter[2]
    local elem = iter[3]

    return as_iter(function(_, _)
        elem = next(data, elem)

        while elem and not fn(elem) do
            elem = next(data, elem)
        end

        return elem
    end, data, elem)
end

--- Reduce each element by function and initial value
--- @param fn function
--- @param init any
--- @param iter iterator
--- @return any
reduce = function(fn, init, iter)
    nd_assert(is_fn(fn), nd_err, 'reduce(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'reduce(): iter must be of type iterator')

    local val = init

    for elem in iter() do
        val = fn(val, elem)
    end

    return val
end

--- Concatenates two iterators
--- @param iter_ iterator
--- @param iter iterator
--- @return iterator
concat = function(iter_, iter)
    nd_assert(is_iter(iter), nd_err, 'concat(): iter must be of type iterator')
    nd_assert(is_iter(iter_), nd_err, 'concat(): iter_ must be of type iterator')

    local next  = iter[1]
    local data  = iter[2]
    local elem  = next(data, iter[3])

    local next_ = iter_[1]
    local data_ = iter_[2]
    local elem_ = next_(data_, iter_[3])

    return as_iter(function(_, _)
        if elem then
            local ret = elem

            elem = next(data, elem)

            return ret
        end

        if elem_ then
            local ret_ = elem_

            elem_ = next_(data_, elem_)

            return ret_
        end
    end, data, elem)
end

--- Zips two iterators
--- @param iter_ iterator
--- @param iter iterator
--- @return iterator
zip = function(iter_, iter)
    nd_assert(is_iter(iter), nd_err, 'zip(): iter must be of type iterator')
    nd_assert(is_iter(iter_), nd_err, 'zip(): iter_ must be of type iterator')

    local next  = iter[1]
    local data  = iter[2]
    local elem  = iter[3]

    local next_ = iter_[1]
    local data_ = iter_[2]
    local elem_ = iter_[3]

    return as_iter(function(_, _)
        elem  = next(data, elem)
        elem_ = next_(data_, elem_)

        return elem and elem_ and { elem, elem_ }
    end, data, elem)
end

--- Takes at most N elements of iterator
--- @param n number
--- @param iter iterator
--- @return iterator
take = function(n, iter)
    nd_assert(n >= 0, nd_err, 'take(): n must not be non-negative')
    nd_assert(is_iter(iter), nd_err, 'take(): iter must be of type iterator')

    local next  = iter[1]
    local data  = iter[2]
    local elem  = iter[3]
    local index = 0

    return as_iter(function(_, _)
        if index < n then
            elem  = next(data, elem)
            index = index + 1

            return elem
        end
    end, data, elem)
end

--- Skips at least N elements of iterator
--- @param n number
--- @param iter iterator
--- @return iterator
skip = function(n, iter)
    nd_assert(n >= 0, nd_err, 'skip(): n must not be non-negative')
    nd_assert(is_iter(iter), nd_err, 'skip(): iter must be of type iterator')

    local next = iter[1]
    local data = iter[2]
    local elem = iter[3]

    return as_iter(function(_, _)
        if n > 0 then
            for _ in range_v(n)() do
                elem = next(data, elem)
            end

            n = 0
        end

        elem = next(data, elem)

        return elem
    end, data, elem)
end

--- Distincts elements of iterator
--- @param fn function|nil
--- @param iter iterator
--- @return iterator
distinct = function(fn, iter)
    nd_assert(is_iter(iter), nd_err, 'distinct(): iter must be of type iterator')

    fn = fn or self

    local set = {}
    local next = iter[1]
    local data = iter[2]
    local elem = iter[3]

    return as_iter(function(_, _)
        repeat
            elem = fn(next(data, elem))
        until not set[elem]

        if elem then
            set[elem] = true
        end

        return elem
    end, data, elem)
end

--- Groups elements of iterator
--- @param fn function
--- @param iter iterator
--- @return tab<key, arr<value>>
group = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'group(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'group(): iter must be of type iterator')

    local res = {}

    for elem in iter() do
        local k = fn(elem)

        if not res[k] then
            res[k] = {}
        end

        local arr = res[k]

        arr[#arr + 1] = elem
    end

    return res
end

--- Counts number of elements in iterator
--- @param iter iterator
--- @return number
count = function(iter)
    nd_assert(is_iter(iter), nd_err, 'count(): iter must be of type iterator')

    local index = 0

    for _ in iter() do
        index = index + 1
    end

    return index
end

--- Checks whether all elements of iterator satisfies fn
--- @param fn function
--- @param iter iterator
--- @return boolean
all = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'all(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'all(): iter must be of type iterator')

    for elem in iter() do
        if not fn(elem) then
            return false
        end
    end

    return true
end

--- Checks whether any element of iterator satisfies fn
--- @param fn function
--- @param iter iterator
--- @return boolean
any = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'any(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'any(): iter must be of type iterator')

    for elem in iter() do
        if fn(elem) then
            return true
        end
    end

    return false
end

--- Adds new val to index of iterator
--- @param val value
--- @param index index
--- @param iter iterator
--- @return iterator
add = function(val, index, iter)
    nd_assert(index > 0, nd_err, 'add(): index must be greater than zero')
    nd_assert(is_iter(iter), nd_err, 'add(): iter must be of type iterator')

    local next = iter[1]
    local data = iter[2]
    local elem = iter[3]
    local ind  = 0

    return as_iter(function(_, _)
        ind = ind + 1

        if ind == index then
            return val
        end

        elem = next(data, elem)

        return elem
    end, data, elem)
end

--- Removes val from index of iterator
--- @param index index
--- @param iter iterator
--- @return iterator
remove = function(index, iter)
    nd_assert(index > 0, nd_err, 'remove(): index must be greater than zero')
    nd_assert(is_iter(iter), nd_err, 'remove(): iter must be of type iterator')

    local next = iter[1]
    local data = iter[2]
    local elem = iter[3]
    local ind  = 0

    return as_iter(function(_, _)
        ind = ind + 1

        if ind == index then
            elem = next(data, elem)
        end

        elem = next(data, elem)

        return elem
    end, data, elem)
end

--- Collects result of iterator in array
--- @param iter iterator
--- @return arr<any>
collect = function(iter)
    nd_assert(is_iter(iter), nd_err, 'collect(): iter must be of type iterator')

    local arr = {}
    local index = 0

    for x in iter() do
        index = index + 1

        arr[index] = x
    end

    return arr
end

--- Applies fn to each element of iterator
--- @param fn function
--- @param iter iterator
each = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'each(): fn must be of type function')
    nd_assert(is_iter(iter), nd_err, 'each(): iter must be of type iterator')

    for elem in iter() do
        fn(elem)
    end
end

--- Pipes iterator over functions
--- @param iter iterator
--- @param args arr<function>
--- @return any
pipe = function(iter, args)
    nd_assert(is_iter(iter), nd_err, 'pipe(): iter must be of type iterator')
    nd_assert(is_tab(args), nd_err, 'pipe(): args must be of type table')

    return reduce(function(val, fn)
        return fn(val)
    end, iter, ivals(args))
end

return {
    is_iter  = is_iter,
    as_iter  = as_iter,
    empty    = empty,
    range_v  = range_v,
    range_iv = range_iv,
    it       = it,
    iv       = iv,
    kv       = kv,
    keys     = keys,
    ivals    = ivals,
    kvals    = kvals,
    mapi     = mapi,
    mapk     = mapk,
    map      = map,
    filter   = filter,
    reduce   = reduce,
    concat   = concat,
    zip      = zip,
    take     = take,
    skip     = skip,
    distinct = distinct,
    group    = group,
    count    = count,
    all      = all,
    any      = any,
    add      = add,
    remove   = remove,
    collect  = collect,
    each     = each,
    pipe     = pipe,
}
