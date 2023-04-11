local fs_lib          = require 'nd.lib.fs'
local stats_lib       = require 'nd.lib.core.stats'
local assert_lib      = require 'nd.lib.core.assert'

local fn_test         = require 'test.fn'
local str_test        = require 'test.str'
local tab_test        = require 'test.tab'
local color_test      = require 'test.color'

local exists          = fs_lib.exists
local create          = fs_lib.create
local enum            = fs_lib.enum
local read_val        = fs_lib.read_val
local write_val       = fs_lib.write_val

local get_bench_stats = stats_lib.get_bench_stats
local get_test_stats  = stats_lib.get_test_stats

local nd_assert       = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err          = assert_lib.get_err_fn 'nd.lib.test'

local format          = string.format

local concat          = table.concat


local get_id                 = nil
local get_full_name          = nil
local get_stats              = nil
local get_bench_report       = nil
local get_test_report        = nil
local get_failed_bench_stats = nil
local get_failed_test_stats  = nil
local run                    = nil


get_id = function(stat)
    return format('%s %s', stat.name, stat.args)
end

get_full_name = function(stat)
    return format('%s: %s', stat.id, stat.name)
end

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

get_bench_report = function(stats, stats_prev)
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

        arr[index] = format('Bench %s.\nArgs: %s\nPrev: %.3e\nCurr: %.3e',
            get_full_name(v),
            v.args,
            time_prev,
            time_curr)
    end

    return concat(arr, '\n')
end

get_test_report = function(stats)
    local arr = {}
    local index = 0

    for _, v in ipairs(stats) do
        index = index + 1

        arr[index] = format('Test %s %s.\nArg: %s\nRes: %s\nRet: %s',
            get_full_name(v),
            v.ok and 'succeed' or 'failed',
            v.args,
            v.res,
            v.ret)
    end

    return concat(arr, '\n')
end

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

run = function(config)
    local cfg = config or {}

    local ext = cfg.ext or 'lua'
    local dir = cfg.dir or 'test/stats'
    local fmt = cfg.fmt or '%Y-%m-%d_%H-%M-%S'
    local eps = cfg.eps or 1e-3
    local save = cfg.save

    local options = {
        sep    = ' ',
        step   = '',
        offset = '',
    }

    local bs = get_stats({
        fn_test.get_bench_cases(),
        str_test.get_bench_cases(),
        tab_test.get_bench_cases(),
        color_test.get_bench_cases(),
    }, get_bench_stats, options)

    local ts = get_stats({
        fn_test.get_test_cases(),
        str_test.get_test_cases(),
        tab_test.get_test_cases(),
        color_test.get_test_cases(),
    }, get_test_stats, options)

    if not exists(dir) then
        create(dir)
    end

    local bs_arr = enum(dir, 'bench-')
    local bs_any = #bs_arr ~= 0

    local bs_last = bs_any and bs_arr[#bs_arr]
    local bs_prev = bs_any and read_val(format('%s/%s', dir, bs_last))

    print()
    print(get_bench_report(bs, bs_prev))
    print()
    print(get_test_report(ts))
    print()

    local bs_failed = get_failed_bench_stats(bs, bs_prev, eps)
    local ts_failed = get_failed_test_stats(ts)

    nd_assert(#bs_failed == 0, nd_err, format('run(): failed bench:\n%s', concat(bs_failed, '\n')))
    nd_assert(#ts_failed == 0, nd_err, format('run(): failed test:\n%s', concat(ts_failed, '\n')))

    if save then
        local time = os.date(fmt)

        write_val(format('%s/bench-%s.%s', dir, time, ext), bs)
        write_val(format('%s/test-%s.%s', dir, time, ext), ts)
    end
end

return {
    run = run,
}
