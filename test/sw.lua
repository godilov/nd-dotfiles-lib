local sw_lib   = require 'nd.lib.core.sw'
local type_lib = require 'nd.lib.core.type'

local is_sw    = sw_lib.is_sw
local start    = sw_lib.start
local stop     = sw_lib.stop
local as_num   = sw_lib.as_num
local as_str   = sw_lib.as_str

local are_eq   = type_lib.are_eq


local get_bench_cases = nil
local get_test_cases  = nil


get_bench_cases = function()
    return {}
end

get_test_cases = function()
    return {}
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
