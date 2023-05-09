local tab_lib    = require 'nd.lib.core.tab'

local concat     = tab_lib.concat
local merge      = tab_lib.merge
local merge_deep = tab_lib.merge_deep
local clone      = tab_lib.clone
local clone_deep = tab_lib.clone_deep


local get_bench_cases = nil
local get_test_cases  = nil


get_bench_cases = function()
    return {}
end

get_test_cases = function()
    return {
        {
            name = 'tab.merge()',
            args = {
                { a = 1, b = 2, c = 3, d = 4 },
                { a = 1, b = 4, c = 3, x = 4, y = 5, z = 6 },
            },
            res = { a = 1, b = 4, c = 3, d = 4, x = 4, y = 5, z = 6 },
            fn = merge,
        },
        {
            name = 'tab.merge_deep()',
            args = {
                { a = { a = 1, b = 2, c = 3, d = 4 } },
                { a = { a = 1, b = 4, c = 3, x = 4, y = 5, z = 6 } },
            },
            res = {
                a = { a = 1, b = 4, c = 3, d = 4, x = 4, y = 5, z = 6 },
            },
            fn = merge_deep,
        },
        {
            name = 'tab.clone()',
            args = { a = 1, b = 2, c = 3, d = 4 },
            res = { a = 1, b = 2, c = 3, d = 4 },
            fn = clone,
        },
        {
            name = 'tab.clone_deep()',
            args = { a = { a = 1, b = 2, c = 3, d = 4 } },
            res = { a = { a = 1, b = 2, c = 3, d = 4 } },
            fn = clone_deep,
        },
        {
            name = 'tab.concat()',
            args = { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } },
            res = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
            fn = concat,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
