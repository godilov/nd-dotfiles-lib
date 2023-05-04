local str_lib = require 'nd.lib.core.str'

local split   = str_lib.split


local split_fn = function(args) return split(args[1], args[2]) end


local get_bench_cases = nil
local get_test_cases  = nil


get_bench_cases = function()
    return {
        {
            name = 'str.split()',
            args = {
                '1 3 3 7 H e l l o , W o r l d 1 3 3 7',
                ' ',
            },
            fn = split_fn,
            n = 1000,
        },
    }
end

get_test_cases = function()
    return {
        {
            name = 'str.split()',
            args = {
                '1 3 3 7 H e l l o , W o r l d 1 3 3 7',
                ' ',
            },
            res = {
                '1', '3', '3', '7',
                'H', 'e', 'l', 'l', 'o',
                ',',
                'W', 'o', 'r', 'l', 'd',
                '1', '3', '3', '7',
            },
            fn = split_fn,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
