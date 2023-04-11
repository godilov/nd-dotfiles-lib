local tab_lib    = require 'nd.lib.core.tab'
local type_lib   = require 'nd.lib.core.type'

local merge      = tab_lib.merge
local merge_deep = tab_lib.merge_deep
local clone      = tab_lib.clone
local clone_deep = tab_lib.clone_deep

local are_eq     = type_lib.are_eq


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
            is_ok = are_eq,
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
            is_ok = are_eq,
        },
        {
            name = 'tab.clone()',
            args = { a = 1, b = 2, c = 3, d = 4 },
            res = { a = 1, b = 2, c = 3, d = 4 },
            fn = clone,
            is_ok = are_eq,
        },
        {
            name = 'tab.clone_deep()',
            args = { a = { a = 1, b = 2, c = 3, d = 4 } },
            res = { a = { a = 1, b = 2, c = 3, d = 4 } },
            fn = clone_deep,
            is_ok = are_eq,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
