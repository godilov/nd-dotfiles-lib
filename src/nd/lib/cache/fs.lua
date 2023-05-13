local fs_lib     = require 'nd.lib.fs'
local str_lib    = require 'nd.lib.core.str'
local type_lib   = require 'nd.lib.core.type'
local assert_lib = require 'nd.lib.core.assert'

local exists     = fs_lib.exists
local read_val   = fs_lib.read_val
local write_val  = fs_lib.write_val

local concat2s   = str_lib.concat2s

local is_str     = type_lib.is_str

local nd_assert  = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err     = assert_lib.get_err_fn 'nd.lib.cache'

local match      = string.match

local dir        = './cache/'
local set_dir    = nil
local get_path   = nil

local set        = nil
local get        = nil


set_dir = function(path)
    nd_assert(is_str(path), nd_err, 'set_dir(): path must be of type string')

    dir = path

    if not match(dir, '[^/]$') then
        dir = concat2s(dir, '/')
    end
end

get_path = function(key)
    nd_assert(is_str(key), nd_err, 'get_path(): key must be of type string')

    return concat2s(dir, key)
end

set = function(key, val)
    write_val(get_path(key), val)
end

get = function(key)
    local path = get_path(key)

    return exists(path) and read_val(path)
end

return {
    set_dir = set_dir,
    set     = set,
    get     = get,
}
