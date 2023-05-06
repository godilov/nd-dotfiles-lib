local fn_lib  = require 'nd.lib.core.fn'
local str_lib = require 'nd.lib.core.str'

local range_v = fn_lib.range_v
local collect = fn_lib.collect

local split   = str_lib.split

local join    = table.concat


local split_fn = function(args) return split(join(collect(range_v(args[1], args[2], args[3])), args[4]), args[4]) end


local get_bench_cases = nil
local get_test_cases  = nil


get_bench_cases = function()
    return {
        {
            name = 'str.split()',
            args = { 1000, 0, 3, ' ' },
            fn = split_fn,
        },
    }
end

get_test_cases = function()
    return {
        {
            name = 'str.split()',
            args = { 4, 1, 3, ' ' },
            res = { '1', '4', '7', '10' },
            fn = split_fn,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
