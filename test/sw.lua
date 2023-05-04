local sw_lib = require 'nd.lib.core.sw'

local is_sw  = sw_lib.is_sw
local start  = sw_lib.start
local stop   = sw_lib.stop
local as_num = sw_lib.as_num
local as_str = sw_lib.as_str
local type   = sw_lib.type

local clock  = os.clock

local match  = string.match


local is_more_or_eq_sw  = nil
local is_more_or_eq_num = nil
local is_similar_str    = nil

local get_bench_cases   = nil
local get_test_cases    = nil


is_more_or_eq_sw = function(x, y)
    return x.start >= y.start and
        x.exec >= y.exec
end

is_more_or_eq_num = function(x, y)
    return x >= y
end

is_similar_str = function(x, y)
    return match(x, y)
end

get_bench_cases = function()
    return {}
end

get_test_cases = function()
    return {
        {
            name = 'sw.is_sw()',
            args = start(),
            res = true,
            fn = is_sw,
        },
        {
            name = 'sw.start()',
            args = nil,
            res = type { clock(), 0 },
            fn = start,
            is_ok = is_more_or_eq_sw,
        },
        {
            name = 'sw.stop()',
            args = start(),
            res = type { clock(), 0 },
            fn = stop,
            is_ok = is_more_or_eq_sw,
        },
        {
            name = 'sw.as_num()',
            args = stop(start()),
            res = 0,
            fn = as_num,
            is_ok = is_more_or_eq_num,
        },
        {
            name = 'sw.as_str()',
            args = stop(start()),
            res = 'Time: [%d%.e+-]+ms',
            fn = as_str,
            is_ok = is_similar_str,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
