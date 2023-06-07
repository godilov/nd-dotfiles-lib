local type_lib      = require 'nd.lib.core.type'
local assert_lib    = require 'nd.lib.core.assert'
local serialize_lib = require 'nd.lib.core.serialize'

local is_str        = type_lib.is_str
local is_fn         = type_lib.is_fn
local are_eq        = type_lib.are_eq

local nd_assert     = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err        = assert_lib.get_err_fn 'nd.lib.core.stats'

local as_str        = serialize_lib.as_str

local clock         = os.clock

local format        = string.format

local concat        = table.concat

local ipairs        = ipairs


local get_bench_stat         = nil
local get_test_stat          = nil
local get_stats_closure      = nil

local get_id                 = nil
local get_full_name          = nil
local get_stats              = nil
local get_bench_report       = nil
local get_test_report        = nil
local get_failed_bench_stats = nil
local get_failed_test_stats  = nil


--- @class benchcase
--- @field id any
--- @field name string
--- @field args any
--- @field fn function
--- @field n? number
--- @field opts? serialize_options

--- @class benchstat
--- @field id any
--- @field name string
--- @field args any
--- @field opts table
--- @field time number

--- Runs a benchmark and returns statistics
--- @param case benchcase
--- @param index number
--- @return benchstat
get_bench_stat = function(case, index)
    nd_assert(is_str(case.name), nd_err, 'get_bench_stat(): case.name must be of type string')
    nd_assert(is_fn(case.fn), nd_err, 'get_bench_stat(): case.fn must be of type function')

    local dt = 0
    local fn = case.fn
    local n  = case.n or 1000

    for _ = 1, n do
        local args = case.args

        local tx = clock()

        local _ = fn(args)

        local ty = clock()

        dt = ty - tx + dt
    end

    return {
        id   = case.id or index,
        name = case.name,
        args = case.args,
        opts = case.opts,
        time = dt / n,
    }
end

--- @class testcase
--- @field id any
--- @field name string
--- @field args any
--- @field res any
--- @field fn function
--- @field opts? serialize_options
--- @field is_ok? function

--- @class teststat
--- @field id any
--- @field name string
--- @field args any
--- @field res any
--- @field opts serialize_options
--- @field ret any
--- @field ok boolean

--- Runs a test and returns statistics
--- @param case testcase
--- @param index number
--- @return teststat
get_test_stat = function(case, index)
    nd_assert(is_str(case.name), nd_err, 'get_test_stat(): case.name must be of type string')
    nd_assert(is_fn(case.fn), nd_err, 'get_test_stat(): case.fn must be of type function')

    local ret = case.fn(case.args)

    return {
        id   = case.id or index,
        name = case.name,
        args = case.args,
        res  = case.res,
        opts = case.opts,
        ret  = ret,
        ok   = case.is_ok and case.is_ok(ret, case.res) or are_eq(ret, case.res),
    }
end

--- Returns full statistics of a cases
--- @param fn function
--- @return function
get_stats_closure = function(fn)
    return function(cases, options)
        local stats = {}

        for i, case in ipairs(cases) do
            stats[i] = fn(case, i, options)
        end

        return stats
    end
end

--- Returns statistic's id
--- @param stat benchstat|teststat
--- @return string
get_id = function(stat)
    return format('%s %s', stat.name, stat.args)
end

--- Returns statistic's fullname
--- @param stat benchstat|teststat
--- @return string
get_full_name = function(stat)
    return format('%s: %s', stat.id, stat.name)
end

--- Runs a bench/test cases and returns statistics
--- @param cases arr<benchcase|testcase>
--- @param fn function
--- @param options? serialize_options
get_stats = function(cases, fn, options)
    local arr = {}
    local index = 0

    for _, v in ipairs(cases) do
        local stats = fn(v, options)

        for _, stat in ipairs(stats) do
            index = index + 1

            arr[index] = stat
        end
    end

    return arr
end

--- Returns report by bench stats
--- @param stats arr<benchstat>
--- @param stats_prev? arr<benchstat>
--- @param options serialize_options
--- @return string
get_bench_report = function(stats, stats_prev, options)
    local time_prev_arr = {}

    for _, v in ipairs(stats_prev or {}) do
        time_prev_arr[get_id(v)] = v.time
    end

    local arr = {}
    local index = 0

    for _, v in ipairs(stats) do
        local time_prev = time_prev_arr[get_id(v)] or 0
        local time_curr = v.time

        index = index + 1

        arr[index] = format('Bench %s.\nArgs: %s\nPrev: %.6fms\nCurr: %.6fms',
            get_full_name(v),
            as_str(v.args, v.opts or options),
            1000 * time_prev,
            1000 * time_curr)
    end

    return concat(arr, '\n-----\n')
end

--- Returns report by test stats
--- @param stats arr<teststat>
--- @param options serialize_options
--- @return string
get_test_report = function(stats, options)
    local arr = {}
    local index = 0

    for _, v in ipairs(stats) do
        index = index + 1

        arr[index] = format('Test %s %s.\nArg: %s\nRes: %s\nRet: %s',
            get_full_name(v),
            v.ok and 'succeed' or 'failed',
            as_str(v.args, v.opts or options),
            as_str(v.res, v.opts or options),
            as_str(v.ret, v.opts or options))
    end

    return concat(arr, '\n----\n')
end

--- Returns failed bench cases names
--- @param stats arr<benchstat>
--- @param stats_prev arr<benchstat>
--- @param eps number
--- @return arr<string>
get_failed_bench_stats = function(stats, stats_prev, eps)
    if not stats_prev then
        return {}
    end

    local time_prev_arr = {}

    for _, v in ipairs(stats_prev) do
        time_prev_arr[get_id(v)] = v.time
    end

    local arr = {}
    local index = 0

    for _, v in ipairs(stats) do
        local time_prev = time_prev_arr[get_id(v)] or 0
        local time_curr = v.time

        if time_curr - time_prev > eps then
            index = index + 1

            arr[index] = get_full_name(v)
        end
    end

    return arr
end

--- Returns failed test cases names
--- @param stats arr<teststat>
--- @return arr<string>
get_failed_test_stats = function(stats)
    local arr = {}
    local index = 0

    for _, v in ipairs(stats) do
        if not v.ok then
            index = index + 1

            arr[index] = get_full_name(v)
        end
    end

    return arr
end

return {
    get_bench_stat         = get_bench_stat,
    get_test_stat          = get_test_stat,
    get_bench_stats        = get_stats_closure(get_bench_stat),
    get_test_stats         = get_stats_closure(get_test_stat),
    get_stats              = get_stats,
    get_bench_report       = get_bench_report,
    get_test_report        = get_test_report,
    get_failed_bench_stats = get_failed_bench_stats,
    get_failed_test_stats  = get_failed_test_stats,
}
