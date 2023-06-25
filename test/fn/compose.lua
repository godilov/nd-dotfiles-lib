local fn_lib   = require 'nd.lib.core.fn.compose'

local shared   = require 'test.fn.shared'

local empty    = fn_lib.empty
local range_v  = fn_lib.range_v
local range_iv = fn_lib.range_iv
local it       = fn_lib.it
local iv       = fn_lib.iv
local kv       = fn_lib.kv
local keys     = fn_lib.keys
local ivals    = fn_lib.ivals
local kvals    = fn_lib.kvals
local map      = fn_lib.map
local filter   = fn_lib.filter
local reduce   = fn_lib.reduce
local concat   = fn_lib.concat
local zip      = fn_lib.zip
local take     = fn_lib.take
local skip     = fn_lib.skip
local distinct = fn_lib.distinct
local group    = fn_lib.group
local count    = fn_lib.count
local all      = fn_lib.all
local any      = fn_lib.any
local add      = fn_lib.add
local remove   = fn_lib.remove
local collect  = fn_lib.collect


local get_bench_cases = shared.get_bench_cases
local get_test_cases  = shared.get_test_cases


local gmatch      = string.gmatch

local join        = table.concat

local empty_fn    = function(_) return empty() * collect() end
local range_v_fn  = function(args) return range_v(args[1], args[2], args[3]) * collect() end
local range_iv_fn = function(args) return range_iv(args[1], args[2], args[3]) * collect() end
local it_fn       = function(args)
    return it(gmatch(join(range_v(args[1], args[2], args[3]) * collect(), args[4]), args[5])) * collect()
end
local iv_fn       = function(args) return iv(range_v(args[1], args[2], args[3]) * collect()) * collect() end
local kv_fn       = function(args) return kv(range_v(args[1], args[2], args[3]) * collect()) * collect() end
local keys_fn     = function(args) return keys(range_v(args[1], args[2], args[3]) * collect()) * collect() end
local ivals_fn    = function(args) return ivals(range_v(args[1], args[2], args[3]) * collect()) * collect() end
local kvals_fn    = function(args) return kvals(range_v(args[1], args[2], args[3]) * collect()) * collect() end
local map_fn      = function(args) return range_v(args[1], args[2], args[3]) * map(args[4]) * collect() end
local filter_fn   = function(args) return range_v(args[1], args[2], args[3]) * filter(args[4]) * collect() end
local reduce_fn   = function(args) return range_v(args[1], args[2], args[3]) * reduce(args[5], args[4]) end
local concat_fn   = function(args)
    return range_v(args[1], args[2], args[3]) * concat(range_v(args[4], args[5], args[6])) * collect()
end
local zip_fn      = function(args)
    return range_v(args[1], args[2], args[3]) * zip(range_v(args[4], args[5], args[6])) * collect()
end
local take_fn     = function(args) return range_v(args[1], args[2], args[3]) * take(args[4]) * collect() end
local skip_fn     = function(args) return range_v(args[1], args[2], args[3]) * skip(args[4]) * collect() end
local distinct_fn = function(args)
    local range = range_v(args[1], args[2], args[3])

    return range * concat(range) * distinct(args[4]) * collect()
end
local group_fn    = function(args) return range_v(args[1], args[2], args[3]) * group(args[4]) end
local count_fn    = function(args) return range_v(args[1], args[2], args[3]) * count() end
local all_fn      = function(args) return range_v(args[1], args[2], args[3]) * all(args[4]) end
local any_fn      = function(args) return range_v(args[1], args[2], args[3]) * any(args[4]) end
local add_fn      = function(args) return range_v(args[1], args[2], args[3]) * add(args[5], args[4]) * collect() end
local remove_fn   = function(args) return range_v(args[1], args[2], args[3]) * remove(args[4]) * collect() end


local fn = {
    empty    = empty_fn,
    range_v  = range_v_fn,
    range_iv = range_iv_fn,
    it       = it_fn,
    iv       = iv_fn,
    kv       = kv_fn,
    keys     = keys_fn,
    ivals    = ivals_fn,
    kvals    = kvals_fn,
    map      = map_fn,
    filter   = filter_fn,
    reduce   = reduce_fn,
    concat   = concat_fn,
    zip      = zip_fn,
    take     = take_fn,
    skip     = skip_fn,
    distinct = distinct_fn,
    group    = group_fn,
    count    = count_fn,
    all      = all_fn,
    any      = any_fn,
    add      = add_fn,
    remove   = remove_fn,
}

return {
    get_bench_cases = get_bench_cases('fn.compose', fn),
    get_test_cases  = get_test_cases('fn.compose', fn),
}
