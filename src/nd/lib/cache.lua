local fs_lib     = require 'nd.lib.fs'
local type_lib   = require 'nd.lib.core.type'
local assert_lib = require 'nd.lib.core.assert'


local read_val  = fs_lib.read_val
local write_val = fs_lib.write_val

local is_str    = type_lib.is_str

local nd_assert = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err    = assert_lib.get_err_fn 'nd.lib.cache'

local format    = string.format
local match     = string.match

local set_dir   = nil
local dir       = './'


local get_path = nil
local set      = nil
local get      = nil


get_path = function(name)
    return format('%s%s', dir, name)
end

set_dir = function(path)
    nd_assert(is_str(path), nd_err, 'set_dir(): path must be of type string')

    dir = path

    if not match(dir, '[^/]$') then
        dir = format('%s%s', dir, '/')
    end
end

set = function(name, val)
    write_val(get_path(name), val)
end

get = function(name)
    return read_val(get_path(name))
end

return {
    set_dir = set_dir,
    set     = set,
    get     = get,
}