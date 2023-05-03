local assert_lib = require 'nd.lib.core.assert'

local nd_assert  = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err     = assert_lib.get_err_fn 'nd.lib.core.sw'

local clock      = os.clock

local format     = string.format


local ffi = require 'ffi'

ffi.cdef [[
    typedef int8_t  i8;
    typedef int16_t i16;
    typedef int32_t i32;
    typedef int64_t i64;

    typedef uint8_t  u8;
    typedef uint16_t u16;
    typedef uint32_t u32;
    typedef uint64_t u64;

    typedef float  f32;
    typedef double f64;

    typedef struct sw {
        u64 start;
        u64 exec;
    } sw_t;
]]

local sw_t   = nil
local is_sw  = nil

local start  = nil
local stop   = nil
local as_num = nil
local as_str = nil


sw_t = ffi.metatype('sw_t', {})

is_sw = function(val)
    return ffi.istype(sw_t, val)
end

start = function(sw)
    return sw_t {
        clock(),
        sw and sw.exec or 0,
    }
end

stop = function(sw)
    nd_assert(is_sw(sw), nd_err, 'stop(): sw must be of type sw')

    local dt = clock() - sw.start

    return sw_t {
        clock(),
        sw.exec + dt,
    }
end

as_num = function(sw)
    nd_assert(is_sw(sw), nd_err, 'as_num(): sw must of type sw')

    return sw.exec
end

as_str = function(sw, options)
    nd_assert(is_sw(sw), nd_err, 'as_str(): sw must of type sw')

    local opts = options or {}

    local fmt = opts.fmt or 'Time: %sms'
    local mul = opts.mul or 1000

    return format(fmt or 'Time: %sms', mul * sw.exec)
end

return {
    is_sw  = is_sw,
    start  = start,
    stop   = stop,
    as_num = as_num,
    as_str = as_str,
}
