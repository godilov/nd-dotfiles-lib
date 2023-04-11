local type_lib   = require 'nd.lib.core.type'
local assert_lib = require 'nd.lib.core.assert'

local is_val     = type_lib.is_val

local nd_assert  = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err     = assert_lib.get_err_fn 'nd.lib.core.sw'

local clock      = os.clock

local format     = string.format


local start  = nil
local stop   = nil
local as_num = nil
local as_str = nil


start = function(sw)
    return {
        start = clock(),
        exec  = sw and sw.exec or 0,
    }
end

stop = function(sw)
    nd_assert(is_val(sw), nd_err, 'stop(): sw must not be nil')

    local dt = sw.start and clock() - sw.start or 0

    return {
        start = clock(),
        exec  = sw.exec + dt,
    }
end

as_num = function(sw)
    nd_assert(is_val(sw), nd_err, 'as_num(): sw must not be nil')

    return sw.exec
end

as_str = function(sw, options)
    nd_assert(is_val(sw), nd_err, 'as_str(): sw must not be nil')

    local opts = options or {}

    local fmt = opts.fmt or 'Time: %sms'
    local mul = opts.mul or 1000

    return format(fmt or 'Time: %sms', mul * sw.exec)
end

return {
    start  = start,
    stop   = stop,
    as_num = as_num,
    as_str = as_str,
}
