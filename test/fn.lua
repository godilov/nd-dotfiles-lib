local fn_lib      = require 'nd.lib.core.fn'

local empty       = fn_lib.empty
local range_v     = fn_lib.range_v
local range_iv    = fn_lib.range_iv
local it          = fn_lib.it
local iv          = fn_lib.iv
local kv          = fn_lib.kv
local keys        = fn_lib.keys
local ivals       = fn_lib.ivals
local kvals       = fn_lib.kvals
local map         = fn_lib.map
local filter      = fn_lib.filter
local reduce      = fn_lib.reduce
local concat      = fn_lib.concat
local zip         = fn_lib.zip
local take        = fn_lib.take
local skip        = fn_lib.skip
local count       = fn_lib.count
local all         = fn_lib.all
local any         = fn_lib.any
local add         = fn_lib.add
local remove      = fn_lib.remove
local collect     = fn_lib.collect

local gmatch      = string.gmatch

local join        = table.concat

local empty_fn    = function(_) return collect(empty()) end
local range_v_fn  = function(args) return collect(range_v(args[1], args[2], args[3])) end
local range_iv_fn = function(args) return collect(range_iv(args[1], args[2], args[3])) end
local it_fn       = function(args)
    return collect(it(gmatch(join(collect(range_v(args[1], args[2], args[3])), args[4]), args[5])))
end
local iv_fn       = function(args) return collect(iv(collect(range_v(args[1], args[2], args[3])))) end
local kv_fn       = function(args) return collect(kv(collect(range_v(args[1], args[2], args[3])))) end
local keys_fn     = function(args) return collect(keys(collect(range_v(args[1], args[2], args[3])))) end
local ivals_fn    = function(args) return collect(ivals(collect(range_v(args[1], args[2], args[3])))) end
local kvals_fn    = function(args) return collect(kvals(collect(range_v(args[1], args[2], args[3])))) end
local map_fn      = function(args) return collect(map(args[4], range_v(args[1], args[2], args[3]))) end
local filter_fn   = function(args) return collect(filter(args[4], range_v(args[1], args[2], args[3]))) end
local reduce_fn   = function(args) return reduce(args[5], args[4], range_v(args[1], args[2], args[3])) end
local concat_fn   = function(args)
    return collect(concat(
        range_v(args[4], args[5], args[6]),
        range_v(args[1], args[2], args[3])
    ))
end
local zip_fn      = function(args)
    return collect(zip(
        range_v(args[4], args[5], args[6]),
        range_v(args[1], args[2], args[3])
    ))
end
local take_fn     = function(args) return collect(take(args[4], range_v(args[1], args[2], args[3]))) end
local skip_fn     = function(args) return collect(skip(args[4], range_v(args[1], args[2], args[3]))) end
local count_fn    = function(args) return count(range_v(args[1], args[2], args[3])) end
local all_fn      = function(args) return all(args[4], range_v(args[1], args[2], args[3])) end
local any_fn      = function(args) return any(args[4], range_v(args[1], args[2], args[3])) end
local add_fn      = function(args) return collect(add(args[5], args[4], range_v(args[1], args[2], args[3]))) end
local remove_fn   = function(args) return collect(remove(args[4], range_v(args[1], args[2], args[3]))) end


local get_bench_cases = nil
local get_test_cases  = nil


get_bench_cases = function()
    return {
        {
            name = 'fn.empty()',
            args = {},
            fn = empty_fn,
        },
        {
            name = 'fn.range_v()',
            args = { 1000, 0, 3 },
            fn = range_v_fn,
        },
        {
            name = 'fn.range_iv()',
            args = { 1000, 0, 3 },
            fn = range_iv_fn,
        },
        {
            name = 'fn.iv()',
            args = { 1000, 0, 3 },
            fn = iv_fn,
        },
        {
            name = 'fn.kv()',
            args = { 1000, 0, 3 },
            fn = kv_fn,
        },
        {
            name = 'fn.keys()',
            args = { 1000, 0, 3 },
            fn = keys_fn,
        },
        {
            name = 'fn.ivals()',
            args = { 1000, 0, 3 },
            fn = ivals_fn,
        },
        {
            name = 'fn.kvals()',
            args = { 1000, 0, 3 },
            fn = kvals_fn,
        },
        {
            name = 'fn.map()',
            args = { 1000, 0, 3, function(x) return x * x end },
            fn = map_fn,
        },
        {
            name = 'fn.filter()',
            args = { 1000, 0, 3, function(x) return x < 1500 end },
            fn = filter_fn,
        },
        {
            name = 'fn.reduce()',
            args = { 1000, 0, 3, 0, function(val, x) return val + x end },
            fn = reduce_fn,
        },
        {
            name = 'fn.concat()',
            args = { 1000, 0, 3, 1000, 0, 7 },
            fn = concat_fn,
        },
        {
            name = 'fn.zip()',
            args = { 1000, 0, 3, 1000, 0, 7 },
            fn = zip_fn,
        },
        {
            name = 'fn.take()',
            args = { 1000, 0, 3, 500 },
            fn = take_fn,
        },
        {
            name = 'fn.skip()',
            args = { 1000, 0, 3, 500 },
            fn = skip_fn,
        },
        {
            name = 'fn.count()',
            args = { 1000, 0, 3 },
            fn = count_fn,
        },
        {
            name = 'fn.all()',
            args = { 1000, 0, 3, function(x) return x >= 0 end },
            fn = all_fn,
        },
        {
            name = 'fn.any()',
            args = { 1000, 0, 3, function(x) return x < 0 end },
            fn = any_fn,
        },
        {
            name = 'fn.add()',
            args = { 1000, 0, 3, 500, -1 },
            fn = add_fn,
        },
        {
            name = 'fn.remove()',
            args = { 1000, 0, 3, 500, -1 },
            fn = remove_fn,
        },
    }
end

get_test_cases = function()
    return {
        {
            name = 'fn.empty()',
            args = {},
            res = {},
            fn = empty_fn,
        },
        {
            name = 'fn.range_v()',
            args = { 5, 1, 2 },
            res = { 1, 3, 5, 7, 9 },
            fn = range_v_fn,
        },
        {
            name = 'fn.range_iv()',
            args = { 5, 1, 2 },
            res = {
                { 1, 1 },
                { 2, 3 },
                { 3, 5 },
                { 4, 7 },
                { 5, 9 },
            },
            fn = range_iv_fn,
        },
        {
            name = 'fn.it()',
            args = { 4, 1, 3, ' ', '[^%s]+' },
            res = { '1', '4', '7', '10' },
            fn = it_fn,
        },
        {
            name = 'fn.iv()',
            args = { 4, 1, 3 },
            res = {
                { 1, 1 },
                { 2, 4 },
                { 3, 7 },
                { 4, 10 },
            },
            fn = iv_fn,
        },
        {
            name = 'fn.kv()',
            args = { 4, 1, 3 },
            res = {
                { 1, 1 },
                { 2, 4 },
                { 3, 7 },
                { 4, 10 },
            },
            fn = kv_fn,
        },
        {
            name = 'fn.keys()',
            args = { 4, 1, 3 },
            res = { 1, 2, 3, 4 },
            fn = keys_fn,
        },
        {
            name = 'fn.ivals()',
            args = { 4, 1, 3 },
            res = { 1, 4, 7, 10 },
            fn = ivals_fn,
        },
        {
            name = 'fn.kvals()',
            args = { 4, 1, 3 },
            res = { 1, 4, 7, 10 },
            fn = kvals_fn,
        },
        {
            name = 'fn.map()',
            args = { 4, 1, 3, function(x) return x * x end },
            res = { 1, 16, 49, 100 },
            fn = map_fn,
        },
        {
            name = 'fn.filter()',
            args = { 4, 1, 3, function(x) return x < 6 end },
            res = { 1, 4 },
            fn = filter_fn,
        },
        {
            name = 'fn.reduce()',
            args = { 4, 1, 3, 0, function(val, x) return val + x end },
            res = 22,
            fn = reduce_fn,
        },
        {
            name = 'fn.concat()',
            args = { 4, 1, 3, 4, 1, 7 },
            res = { 1, 4, 7, 10, 1, 8, 15, 22 },
            fn = concat_fn,
        },
        {
            name = 'fn.zip()',
            args = { 4, 1, 3, 4, 1, 7 },
            res = {
                { 1,  1 },
                { 4,  8 },
                { 7,  15 },
                { 10, 22 },
            },
            fn = zip_fn,
        },
        {
            name = 'fn.take()',
            args = { 4, 1, 3, 2 },
            res = { 1, 4 },
            fn = take_fn,
        },
        {
            name = 'fn.skip()',
            args = { 4, 1, 3, 2 },
            res = { 7, 10 },
            fn = skip_fn,
        },
        {
            name = 'fn.count()',
            args = { 4, 1, 3 },
            res = 4,
            fn = count_fn,
        },
        {
            name = 'fn.all()',
            args = { 4, 1, 3, function(x) return x > 0 end },
            res = true,
            fn = all_fn,
        },
        {
            name = 'fn.any()',
            args = { 4, 1, 3, function(x) return x < 0 end },
            res = false,
            fn = any_fn,
        },
        {
            name = 'fn.add()',
            args = { 4, 1, 3, 3, 6 },
            res = { 1, 4, 6, 7, 10 },
            fn = add_fn,
        },
        {
            name = 'fn.remove()',
            args = { 4, 1, 3, 3 },
            res = { 1, 4, 10 },
            fn = remove_fn,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
