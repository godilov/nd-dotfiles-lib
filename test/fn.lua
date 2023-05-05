local fn_lib   = require 'nd.lib.core.fn'

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
local count    = fn_lib.count
local all      = fn_lib.all
local any      = fn_lib.any
local add      = fn_lib.add
local remove   = fn_lib.remove
local collect  = fn_lib.collect

local gmatch   = string.gmatch

local pairs    = pairs


local empty_fn    = function(_) return collect(empty()) end
local range_v_fn  = function(args) return collect(range_v(args[1], args[2], args[3])) end
local range_iv_fn = function(args) return collect(range_iv(args[1], args[2], args[3])) end
local it_fn       = function(args) return collect(it(gmatch(args[1], args[2]))) end
local iv_fn       = function(args) return collect(iv(args)) end
local kv_fn       = function(args) return collect(kv(args)) end
local keys_fn     = function(args) return collect(keys(args)) end
local ivals_fn    = function(args) return collect(ivals(args)) end
local kvals_fn    = function(args) return collect(kvals(args)) end
local map_fn      = function(args) return collect(map(args[2], ivals(args[1]))) end
local filter_fn   = function(args) return collect(filter(args[2], ivals(args[1]))) end
local reduce_fn   = function(args) return reduce(args[3], args[1], ivals(args[2])) end
local concat_fn   = function(args) return collect(concat(ivals(args[1]), ivals(args[2]))) end
local zip_fn      = function(args) return collect(zip(ivals(args[1]), ivals(args[2]))) end
local take_fn     = function(args) return collect(take(args[1], ivals(args[2]))) end
local skip_fn     = function(args) return collect(skip(args[1], ivals(args[2]))) end
local count_fn    = function(args) return count(range_v(args[1])) end
local all_fn      = function(args) return all(args[2], ivals(args[1])) end
local any_fn      = function(args) return any(args[2], ivals(args[1])) end
local add_fn      = function(args) return collect(add(args[1], args[2], ivals(args[3]))) end
local remove_fn   = function(args) return collect(remove(args[1], ivals(args[2]))) end


local range_v_fn_bench  = range_v_fn
local range_iv_fn_bench = range_iv_fn
local iv_fn_bench       = function(args) return collect(iv(collect(range_v(args[1], args[2], args[3])))) end
local kv_fn_bench       = function(args) return collect(kv(collect(range_v(args[1], args[2], args[3])))) end
local keys_fn_bench     = function(args) return collect(keys(collect(range_v(args[1], args[2], args[3])))) end
local ivals_fn_bench    = function(args) return collect(ivals(collect(range_v(args[1], args[2], args[3])))) end
local kvals_fn_bench    = function(args) return collect(kvals(collect(range_v(args[1], args[2], args[3])))) end
local map_fn_bench      = function(args) return collect(map(args[4], range_v(args[1], args[2], args[3]))) end
local filter_fn_bench   = function(args) return collect(filter(args[4], range_v(args[1], args[2], args[3]))) end
local reduce_fn_bench   = function(args) return reduce(args[5], args[4], range_v(args[1], args[2], args[3])) end
local concat_fn_bench   = function(args)
    return collect(concat(
        range_v(args[4], args[5], args[6]),
        range_v(args[1], args[2], args[3])
    ))
end
local zip_fn_bench      = function(args)
    return collect(zip(
        range_v(args[4], args[5], args[6]),
        range_v(args[1], args[2], args[3])
    ))
end
local take_fn_bench     = function(args) return collect(take(args[4], range_v(args[1], args[2], args[3]))) end
local skip_fn_bench     = function(args) return collect(skip(args[4], range_v(args[1], args[2], args[3]))) end
local count_fn_bench    = function(args) return count(range_v(args[1], args[2], args[3])) end
local all_fn_bench      = function(args) return all(args[4], range_v(args[1], args[2], args[3])) end
local any_fn_bench      = function(args) return any(args[4], range_v(args[1], args[2], args[3])) end
local add_fn_bench      = function(args) return collect(add(args[5], args[4], range_v(args[1], args[2], args[3]))) end
local remove_fn_bench   = function(args) return collect(remove(args[4], range_v(args[1], args[2], args[3]))) end


local kv_eq           = nil
local keys_eq         = nil

local get_bench_cases = nil
local get_test_cases  = nil


kv_eq = function(x, y)
    if #x ~= #y then
        return false
    end

    local t = {}

    for _, xv in pairs(x) do
        t[xv[1]] = xv[2]
    end

    for _, yv in pairs(y) do
        if t[yv[1]] ~= yv[2] then
            return false
        end
    end

    return true
end

keys_eq = function(x, y)
    if #x ~= #y then
        return false
    end

    local t = {}

    for _, xv in pairs(x) do
        t[xv] = true
    end

    for _, yv in pairs(y) do
        if not t[yv] then
            return false
        end
    end

    return true
end

get_bench_cases = function()
    return {
        {
            name = 'fn.range_v()',
            args = { 1000, 0, 3 },
            fn = range_v_fn_bench,
        },
        {
            name = 'fn.range_iv()',
            args = { 1000, 0, 3 },
            fn = range_iv_fn_bench,
        },
        {
            name = 'fn.iv()',
            args = { 1000, 0, 3 },
            fn = iv_fn_bench,
        },
        {
            name = 'fn.kv()',
            args = { 1000, 0, 3 },
            fn = kv_fn_bench,
        },
        {
            name = 'fn.keys()',
            args = { 1000, 0, 3 },
            fn = keys_fn_bench,
        },
        {
            name = 'fn.ivals()',
            args = { 1000, 0, 3 },
            fn = ivals_fn_bench,
        },
        {
            name = 'fn.kvals()',
            args = { 1000, 0, 3 },
            fn = kvals_fn_bench,
        },
        {
            name = 'fn.map()',
            args = { 1000, 0, 3, function(x) return x * x end },
            fn = map_fn_bench,
        },
        {
            name = 'fn.filter()',
            args = { 1000, 0, 3, function(x) return x < 1500 end },
            fn = filter_fn_bench,
        },
        {
            name = 'fn.reduce()',
            args = { 1000, 0, 3, 0, function(val, x) return val + x end },
            fn = reduce_fn_bench,
        },
        {
            name = 'fn.concat()',
            args = { 1000, 0, 3, 1000, 0, 7 },
            fn = concat_fn_bench,
        },
        {
            name = 'fn.zip()',
            args = { 1000, 0, 3, 1000, 0, 7 },
            fn = zip_fn_bench,
        },
        {
            name = 'fn.take()',
            args = { 1000, 0, 3, 500 },
            fn = take_fn_bench,
        },
        {
            name = 'fn.skip()',
            args = { 1000, 0, 3, 500 },
            fn = skip_fn_bench,
        },
        {
            name = 'fn.count()',
            args = { 1000, 0, 3 },
            fn = count_fn_bench,
        },
        {
            name = 'fn.all()',
            args = { 1000, 0, 3, function(x) return x >= 0 end },
            fn = all_fn_bench,
        },
        {
            name = 'fn.any()',
            args = { 1000, 0, 3, function(x) return x < 0 end },
            fn = any_fn_bench,
        },
        {
            name = 'fn.add()',
            args = { 1000, 0, 3, 500, -1 },
            fn = add_fn_bench,
        },
        {
            name = 'fn.remove()',
            args = { 1000, 0, 3, 500, -1 },
            fn = remove_fn_bench,
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
            args = { '1 2 3 4 5', '[^%s]+' },
            res = { '1', '2', '3', '4', '5' },
            fn = it_fn,
        },
        {
            name = 'fn.iv()',
            args = { a = 9, b = 8, c = 7, d = 6, e = 5, 5, 4, 3, 2, 1 },
            res = {
                { 1, 5 },
                { 2, 4 },
                { 3, 3 },
                { 4, 2 },
                { 5, 1 },
            },
            fn = iv_fn,
        },
        {
            name = 'fn.kv()',
            args = { a = 9, b = 8, c = 7, d = 6, e = 5, 5, 4, 3, 2, 1 },
            res = {
                { 'a', 9 },
                { 'b', 8 },
                { 'c', 7 },
                { 'd', 6 },
                { 'e', 5 },
                { 1,   5 },
                { 2,   4 },
                { 3,   3 },
                { 4,   2 },
                { 5,   1 },
            },
            fn = kv_fn,
            is_ok = kv_eq,
        },
        {
            name = 'fn.keys()',
            args = { a = 9, b = 8, c = 7, d = 6, e = 5, 5, 4, 3, 2, 1 },
            res = { 'a', 'b', 'c', 'd', 'e', 1, 2, 3, 4, 5 },
            fn = keys_fn,
            is_ok = keys_eq,
        },
        {
            name = 'fn.ivals()',
            args = { a = 9, b = 8, c = 7, d = 6, e = 5, 5, 4, 3, 2, 1 },
            res = { 5, 4, 3, 2, 1 },
            fn = ivals_fn,
        },
        {
            name = 'fn.kvals()',
            args = { a = 9, b = 8, c = 7, d = 6, e = 5, 5, 4, 3, 2, 1 },
            res = { 9, 8, 7, 6, 5, 5, 4, 3, 2, 1 },
            fn = kvals_fn,
            is_ok = keys_eq,
        },
        {
            name = 'fn.map()',
            args = {
                { 5, 4, 3, 2, 1 },
                function(x) return x * x end,
            },
            res = { 25, 16, 9, 4, 1 },
            fn = map_fn,
        },
        {
            name = 'fn.filter()',
            args = {
                { 5, 4, 3, 2, 1 },
                function(x) return x < 3 end,
            },
            res = { 2, 1 },
            fn = filter_fn,
        },
        {
            name = 'fn.reduce()',
            args = {
                6,
                { 5, 4, 3, 2, 1 },
                function(val, x) return val + x end,
            },
            res = 21,
            fn = reduce_fn,
        },
        {
            name = 'fn.concat()',
            args = {
                { 9, 8, 7, 6, 5 },
                { 5, 4, 3, 2, 1 },
            },
            res = { 5, 4, 3, 2, 1, 9, 8, 7, 6, 5 },
            fn = concat_fn,
        },
        {
            name = 'fn.zip()',
            args = {
                { 9, 8, 7, 6, 5 },
                { 5, 4, 3, 2, 1 },
            },
            res = {
                { 5, 9 },
                { 4, 8 },
                { 3, 7 },
                { 2, 6 },
                { 1, 5 },
            },
            fn = zip_fn,
        },
        {
            name = 'fn.take()',
            args = {
                3,
                { 5, 4, 3, 2, 1 },
            },
            res = { 5, 4, 3 },
            fn = take_fn,
        },
        {
            name = 'fn.skip()',
            args = {
                3,
                { 5, 4, 3, 2, 1 },
            },
            res = { 2, 1 },
            fn = skip_fn,
        },
        {
            name = 'fn.count()',
            args = { 1000 },
            res = 1000,
            fn = count_fn,
        },
        {
            name = 'fn.all()',
            args = {
                { 5, 4, 3, 2, 1 },
                function(x) return x < 6 end,
            },
            res = true,
            fn = all_fn,
        },
        {
            name = 'fn.any()',
            args = {
                { 5, 4, 3, 2, 1 },
                function(x) return x == 3 end,
            },
            res = true,
            fn = any_fn,
        },
        {
            name = 'fn.add()',
            args = {
                6,
                3,
                { 5, 4, 3, 2, 1 },
            },
            res = { 5, 4, 6, 3, 2, 1 },
            fn = add_fn,
        },
        {
            name = 'fn.remove()',
            args = {
                3,
                { 5, 4, 3, 2, 1 },
            },
            res = { 5, 4, 2, 1 },
            fn = remove_fn,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
