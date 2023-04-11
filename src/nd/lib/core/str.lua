local fn_lib  = require 'nd.lib.core.fn'

local it      = fn_lib.it

local collect = fn_lib.collect

local gmatch  = string.gmatch
local format  = string.format


local split = nil


split = function(str, sep)
    return collect(it(gmatch(str, format('[^%s]+', sep or '%s'))))
end

return {
    split = split,
}
