local fn_lib   = require 'nd.lib.core.fn'
local type_lib = require 'nd.lib.core.type'

local empty    = fn_lib.empty
local range    = fn_lib.range
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
local all      = fn_lib.all
local any      = fn_lib.any
local add      = fn_lib.add
local remove   = fn_lib.remove
local collect  = fn_lib.collect

local are_eq   = type_lib.are_eq

local gmatch   = string.gmatch

local pairs    = pairs


local empty_fn  = function(_) return collect(empty()) end
local range_fn  = function(args) return collect(range(args[1], args[2], args[3])) end
local it_fn     = function(args) return collect(it(gmatch(args[1], args[2]))) end
local iv_fn     = function(args) return collect(iv(args)) end
local kv_fn     = function(args) return collect(kv(args)) end
local keys_fn   = function(args) return collect(keys(args)) end
local ivals_fn  = function(args) return collect(ivals(args)) end
local kvals_fn  = function(args) return collect(kvals(args)) end
local map_fn    = function(args) return collect(map(args[2], ivals(args[1]))) end
local filter_fn = function(args) return collect(filter(args[2], ivals(args[1]))) end
local reduce_fn = function(args) return reduce(args[3], args[1], ivals(args[2])) end
local concat_fn = function(args) return collect(concat(ivals(args[1]), ivals(args[2]))) end
local zip_fn    = function(args) return collect(zip(ivals(args[1]), ivals(args[2]))) end
local take_fn   = function(args) return collect(take(args[1], ivals(args[2]))) end
local skip_fn   = function(args) return collect(skip(args[1], ivals(args[2]))) end
local all_fn    = function(args) return all(args[2], ivals(args[1])) end
local any_fn    = function(args) return any(args[2], ivals(args[1])) end
local add_fn    = function(args) return collect(add(args[1], args[2], ivals(args[3]))) end
local remove_fn = function(args) return collect(remove(args[1], ivals(args[2]))) end


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
            name = 'fn.empty()',
            args = {},
            fn = empty_fn,
            n = 1000,
        },
        {
            name = 'fn.range()',
            args = { 1000, 1, 2 },
            fn = range_fn,
            n = 1000,
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
            is_ok = are_eq,
        },
        {
            name = 'fn.range()',
            args = { 10, 1, 2 },
            res = {
                { 1, 1 },
                { 2, 3 },
                { 3, 5 },
                { 4, 7 },
                { 5, 9 },
            },
            fn = range_fn,
            is_ok = are_eq,
        },
        {
            name = 'fn.it()',
            args = { '1 2 3 4 5', '[^%s]+' },
            res = { '1', '2', '3', '4', '5' },
            fn = it_fn,
            is_ok = are_eq,
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
            is_ok = are_eq,
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
            is_ok = are_eq,
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
            is_ok = are_eq,
        },
        {
            name = 'fn.filter()',
            args = {
                { 5, 4, 3, 2, 1 },
                function(x) return x < 3 end,
            },
            res = { 2, 1 },
            fn = filter_fn,
            is_ok = are_eq,
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
            is_ok = are_eq,
        },
        {
            name = 'fn.concat()',
            args = {
                { 9, 8, 7, 6, 5 },
                { 5, 4, 3, 2, 1 },
            },
            res = { 5, 4, 3, 2, 1, 9, 8, 7, 6, 5 },
            fn = concat_fn,
            is_ok = are_eq,
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
            is_ok = are_eq,
        },
        {
            name = 'fn.take()',
            args = {
                3,
                { 5, 4, 3, 2, 1 },
            },
            res = { 5, 4, 3 },
            fn = take_fn,
            is_ok = are_eq,
        },
        {
            name = 'fn.skip()',
            args = {
                3,
                { 5, 4, 3, 2, 1 },
            },
            res = { 2, 1 },
            fn = skip_fn,
            is_ok = are_eq,
        },
        {
            name = 'fn.all()',
            args = {
                { 5, 4, 3, 2, 1 },
                function(x) return x < 6 end,
            },
            res = true,
            fn = all_fn,
            is_ok = are_eq,
        },
        {
            name = 'fn.any()',
            args = {
                { 5, 4, 3, 2, 1 },
                function(x) return x == 3 end,
            },
            res = true,
            fn = any_fn,
            is_ok = are_eq,
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
            is_ok = are_eq,
        },
        {
            name = 'fn.remove()',
            args = {
                3,
                { 5, 4, 3, 2, 1 },
            },
            res = { 5, 4, 2, 1 },
            fn = remove_fn,
            is_ok = are_eq,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
