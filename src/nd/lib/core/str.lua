local fn_lib  = require 'nd.lib.core.fn'

local it      = fn_lib.it

local collect = fn_lib.collect

local gmatch  = string.gmatch
local format  = string.format
local rep     = string.rep

local unpack  = table.unpack


local split    = nil
local concat   = nil
local concat2s = nil
local concat3s = nil
local concat4s = nil


split = function(str, sep)
    return collect(it(gmatch(str, format('[^%s]+', sep or '%s'))))
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
    split    = split,
    concat   = concat,
    concat2s = concat2s,
    concat3s = concat3s,
    concat4s = concat4s,
}
