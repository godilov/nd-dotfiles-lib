local fn_lib   = require 'nd.lib.core.fn'

local it       = fn_lib.it
local collect  = fn_lib.collect

local format   = string.format
local gmatch   = string.gmatch
local match    = string.match
local rep      = string.rep

local unpack   = table.unpack

local starts   = nil
local ends     = nil
local split_it = nil
local split    = nil
local trim     = nil
local concat   = nil
local concat2s = nil
local concat3s = nil
local concat4s = nil


--- Checks if string starts with pattern
--- @param str string
--- @param pattern string
starts = function(str, pattern)
    return match(str, format('^({})+', pattern))
end

--- Checks if string ends with pattern
--- @param str string
--- @param pattern string
ends = function(str, pattern)
    return match(str, format('({})+$', pattern))
end

split_it = function(str, sep)
    return it(gmatch(str, format('[^%s]+', sep or '%s')))
end

split = function(str, sep)
    return collect(split_it(str, sep))
end

trim = function(str, x)
    local val = x or ' '

    return match(str, format('({})*.*({})*', val, val))
end

concat = function(args, sep)
    return format(rep('%s', #args, sep), unpack(args))
end

concat2s = function(s1, s2)
    return format('%s%s', s1, s2)
end

concat3s = function(s1, s2, s3)
    return format('%s%s%s', s1, s2, s3)
end

concat4s = function(s1, s2, s3, s4)
    return format('%s%s%s%s', s1, s2, s3, s4)
end

return {
    starts   = starts,
    ends     = ends,
    split_it = split_it,
    split    = split,
    trim     = trim,
    concat   = concat,
    concat2s = concat2s,
    concat3s = concat3s,
    concat4s = concat4s,
}
