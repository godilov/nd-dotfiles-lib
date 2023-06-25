local fn_lib     = require 'nd.lib.core.fn'
local type_lib   = require 'nd.lib.core.type'
local assert_lib = require 'nd.lib.core.assert'

local is_num     = type_lib.is_num
local is_fn      = type_lib.is_fn

local nd_assert  = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err     = assert_lib.get_err_fn 'nd.lib.core.fn.compose'


local is_iter       = fn_lib.is_iter
local as_iter       = fn_lib.as_iter

local empty         = fn_lib.empty
local range_v       = fn_lib.range_v
local range_iv      = fn_lib.range_iv
local it_impl       = fn_lib.it
local iv_impl       = fn_lib.iv
local kv_impl       = fn_lib.kv
local keys_impl     = fn_lib.keys
local ivals_impl    = fn_lib.ivals
local kvals_impl    = fn_lib.kvals
local mapi_impl     = fn_lib.mapi
local mapk_impl     = fn_lib.mapk

local map_impl      = fn_lib.map
local filter_impl   = fn_lib.filter
local reduce_impl   = fn_lib.reduce
local concat_impl   = fn_lib.concat
local zip_impl      = fn_lib.zip
local take_impl     = fn_lib.take
local skip_impl     = fn_lib.skip
local distinct_impl = fn_lib.distinct
local group_impl    = fn_lib.group
local count_impl    = fn_lib.count
local all_impl      = fn_lib.all
local any_impl      = fn_lib.any
local add_impl      = fn_lib.add
local remove_impl   = fn_lib.remove
local collect_impl  = fn_lib.collect
local each_impl     = fn_lib.each
local pipe          = fn_lib.pipe

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


--- Maps each element by index
--- @param i index
--- @param iter? iterator
--- @return iterator|function
mapi = function(i, iter)
    nd_assert(is_num(i), nd_err, 'mapi(): i must be of type number')

    return iter and mapi_impl(i, iter) or function(iter_ext)
        return mapi_impl(i, iter_ext)
    end
end

--- Maps each element by key
--- @param k key
--- @param iter? iterator
--- @return iterator|function
mapk = function(k, iter)
    nd_assert(k, nd_err, 'mapk(): k must be of type value')

    return iter and mapk_impl(k, iter) or function(iter_ext)
        return mapk_impl(k, iter_ext)
    end
end

--- Maps each element by function
--- @param fn function
--- @param iter? iterator
--- @return iterator|function
map = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'map(): fn must be of type function')

    return iter and map_impl(fn, iter) or function(iter_ext)
        return map_impl(fn, iter_ext)
    end
end

--- Filters each element by function
--- @param fn function
--- @param iter? iterator
--- @return iterator|function
filter = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'filter(): fn must be of type function')

    return iter and filter_impl(fn, iter) or function(iter_ext)
        return filter_impl(fn, iter_ext)
    end
end

--- Reduce each element by function and initial value
--- @param fn function
--- @param init any
--- @param iter? iterator
--- @return iterator|function
reduce = function(fn, init, iter)
    nd_assert(is_fn(fn), nd_err, 'reduce(): fn must be of type function')

    return iter and reduce_impl(fn, init, iter) or function(iter_ext)
        return reduce_impl(fn, init, iter_ext)
    end
end

--- Concatenates two iterators
--- @param iter_ iterator
--- @param iter? iterator
--- @return iterator|function
concat = function(iter_, iter)
    nd_assert(is_iter(iter_), nd_err, 'concat(): iter_ must be of type iterator')

    return iter and concat_impl(iter_, iter) or function(iter_ext)
        return concat_impl(iter_, iter_ext)
    end
end

--- Zips two iterators
--- @param iter_ iterator
--- @param iter? iterator
--- @return iterator|function
zip = function(iter_, iter)
    nd_assert(is_iter(iter_), nd_err, 'zip(): iter_ must be of type iterator')

    return iter and zip_impl(iter_, iter) or function(iter_ext)
        return zip_impl(iter_, iter_ext)
    end
end

--- Takes at most N elements of iterator
--- @param n number
--- @param iter? iterator
--- @return iterator|function
take = function(n, iter)
    nd_assert(n >= 0, nd_err, 'take(): n must not be non-negative')

    return iter and take_impl(n, iter) or function(iter_ext)
        return take_impl(n, iter_ext)
    end
end

--- Skips at least N elements of iterator
--- @param n number
--- @param iter? iterator
--- @return iterator|function
skip = function(n, iter)
    nd_assert(n >= 0, nd_err, 'skip(): n must not be non-negative')

    return iter and skip_impl(n, iter) or function(iter_ext)
        return skip_impl(n, iter_ext)
    end
end

--- Distincts elements of iterator
--- @param fn function|nil
--- @param iter? iterator
--- @return iterator|function
distinct = function(fn, iter)
    return iter and distinct_impl(fn, iter) or function(iter_ext)
        return distinct_impl(fn, iter_ext)
    end
end

--- Groups elements of iterator
--- @param fn function
--- @param iter? iterator
--- @return tab<key, arr<value>>|function
group = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'group(): fn must be of type function')

    return iter and group_impl(fn, iter) or function(iter_ext)
        return group_impl(fn, iter_ext)
    end
end

--- Counts number of elements in iterator
--- @param iter? iterator
--- @return number|function
count = function(iter)
    return iter and count_impl(iter) or function(iter_ext)
        return count_impl(iter_ext)
    end
end

--- Checks whether all elements of iterator satisfies fn
--- @param fn function
--- @param iter? iterator
--- @return boolean|function
all = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'all(): fn must be of type function')

    return iter and all_impl(fn, iter) or not iter and function(iter_ext)
        return all_impl(fn, iter_ext)
    end
end

--- Checks whether any element of iterator satisfies fn
--- @param fn function
--- @param iter? iterator
--- @return boolean|function
any = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'any(): fn must be of type function')

    return iter and any_impl(fn, iter) or not iter and function(iter_ext)
        return any_impl(fn, iter_ext)
    end
end

--- Adds new val to index of iterator
--- @param val value
--- @param index number
--- @param iter? iterator
--- @return iterator|function
add = function(val, index, iter)
    nd_assert(index > 0, nd_err, 'add(): index must be greater than zero')

    return iter and add_impl(val, index, iter) or function(iter_ext)
        return add_impl(val, index, iter_ext)
    end
end

--- Removes val from index of iterator
--- @param index number
--- @param iter? iterator
--- @return iterator|function
remove = function(index, iter)
    nd_assert(index > 0, nd_err, 'remove(): index must be greater than zero')

    return iter and remove_impl(index, iter) or function(iter_ext)
        return remove_impl(index, iter_ext)
    end
end

--- Collects result of iterator in array
--- @param iter? iterator
--- @return arr<any>|function
collect = function(iter)
    return iter and collect_impl(iter) or function(iter_ext)
        return collect_impl(iter_ext)
    end
end

--- Applies fn to each element of iterator
--- @param fn function
--- @param iter? iterator
--- @return nil|function
each = function(fn, iter)
    nd_assert(is_fn(fn), nd_err, 'each(): fn must be of type function')

    return iter and each_impl(fn, iter) or function(iter_ext)
        return each_impl(fn, iter_ext)
    end
end

return {
    is_iter  = is_iter,
    as_iter  = as_iter,
    empty    = empty,
    range_v  = range_v,
    range_iv = range_iv,
    it       = it_impl,
    iv       = iv_impl,
    kv       = kv_impl,
    keys     = keys_impl,
    ivals    = ivals_impl,
    kvals    = kvals_impl,
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
