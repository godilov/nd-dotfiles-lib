local type_lib      = require 'nd.lib.core.type'
local assert_lib    = require 'nd.lib.core.assert'
local serialize_lib = require 'nd.lib.core.serialize'

local is_num        = type_lib.is_num
local is_str        = type_lib.is_str
local is_fn         = type_lib.is_fn

local nd_assert     = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err        = assert_lib.get_err_fn 'nd.lib.core.stats'

local as_str        = serialize_lib.as_str

local clock         = os.clock

local ipairs        = ipairs


local get_bench_stat = nil
local get_test_stat  = nil
local get_stats      = nil


get_bench_stat = function(case, index, options)
    nd_assert(is_str(case.name), nd_err, 'get_bench_stat(): case.name must be of type string')
    nd_assert(is_fn(case.fn), nd_err, 'get_bench_stat(): case.fn must be of type function')
    nd_assert(is_num(case.n), nd_err, 'get_bench_stat(): case.n must be of type number')

    local dt = 0
    local fn = case.fn
    local n  = case.n

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
        args = as_str(case.args, options),
        time = dt / case.n,
    }
end

get_test_stat = function(case, index, options)
    nd_assert(is_str(case.name), nd_err, 'get_test_stat(): case.name must be of type string')
    nd_assert(is_fn(case.fn), nd_err, 'get_test_stat(): case.fn must be of type function')

    local ret = case.fn(case.args)

    return {
        id   = case.id or index,
        name = case.name,
        args = as_str(case.args, options),
        res  = as_str(case.res, options),
        ret  = as_str(ret, options),
        ok   = case.is_ok and case.is_ok(ret, case.res) or ret == case.res,
    }
end

get_stats = function(fn)
    return function(cases, options)
        local stats = {}

        for i, case in ipairs(cases) do
            stats[i] = fn(case, i, options)
        end

        return stats
    end
end

return {
    get_bench_stat  = get_bench_stat,
    get_test_stat   = get_test_stat,
    get_bench_stats = get_stats(get_bench_stat),
    get_test_stats  = get_stats(get_test_stat),
}
