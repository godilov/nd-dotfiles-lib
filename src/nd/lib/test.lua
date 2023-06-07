local fs_lib          = require 'nd.lib.fs'
local stats_lib       = require 'nd.lib.core.stats'
local assert_lib      = require 'nd.lib.core.assert'

local enum            = fs_lib.enum
local read_val        = fs_lib.read_val
local write_val       = fs_lib.write_val

local get_bench_stats = stats_lib.get_bench_stats
local get_test_stats  = stats_lib.get_test_stats

local nd_assert       = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err          = assert_lib.get_err_fn 'nd.lib.test'

local format          = string.format

local concat          = table.concat

local date            = os.date

local ipairs          = ipairs


local get_stats              = stats_lib.get_stats
local get_bench_report       = stats_lib.get_bench_report
local get_test_report        = stats_lib.get_test_report
local get_failed_bench_stats = stats_lib.get_failed_bench_stats
local get_failed_test_stats  = stats_lib.get_failed_test_stats


local get_bench_cases = nil
local get_test_cases  = nil
local get_cases_arr   = nil


get_bench_cases = function(elem)
    return elem.get_bench_cases()
end

get_test_cases = function(elem)
    return elem.get_test_cases()
end

get_cases_arr = function(arr, fn)
    local i = 0
    local t = {}

    for _, v in ipairs(arr) do
        i = i + 1

        t[i] = fn(v)
    end

    return t
end

return function(arr, config, options)
    local cfg    = config or {}

    local ext    = cfg.ext or 'lua'
    local dir    = cfg.dir or 'test/stats'
    local fmt    = cfg.fmt or '%Y-%m-%d_%H-%M-%S'
    local eps    = cfg.eps or 1e-3
    local save   = cfg.save

    local opts_  = options or {}

    local sep    = opts_.sep or ' '
    local step   = opts_.step or ''
    local offset = opts_.offset or ''

    local opts   = {
        sep    = sep,
        step   = step,
        offset = offset,
    }


    local bs = get_stats(get_cases_arr(arr, get_bench_cases), get_bench_stats)
    local ts = get_stats(get_cases_arr(arr, get_test_cases), get_test_stats)

    local bs_arr = enum(dir, 'bench-')
    local bs_any = #bs_arr ~= 0

    local bs_last = bs_any and bs_arr[#bs_arr]
    local bs_prev = bs_any and read_val(format('%s/%s', dir, bs_last))

    --- @cast bs_prev arr<benchstat>

    print()
    print(get_bench_report(bs, bs_prev, opts))
    print()
    print(get_test_report(ts, opts))
    print()

    local bs_failed = get_failed_bench_stats(bs, bs_prev, eps)
    local ts_failed = get_failed_test_stats(ts)

    nd_assert(#bs_failed == 0, nd_err, format('run(): failed bench:\n%s', concat(bs_failed, '\n')))
    nd_assert(#ts_failed == 0, nd_err, format('run(): failed test:\n%s', concat(ts_failed, '\n')))

    if save then
        local time = date(fmt)

        write_val(format('%s/bench-%s.%s', dir, time, ext), bs)
        write_val(format('%s/test-%s.%s', dir, time, ext), ts)
    end
end
