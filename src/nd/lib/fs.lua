local type_lib      = require 'nd.lib.core.type'
local assert_lib    = require 'nd.lib.core.assert'
local serialize_lib = require 'nd.lib.core.serialize'

local is_val        = type_lib.is_val
local is_str        = type_lib.is_str
local is_tab        = type_lib.is_tab

local nd_assert     = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err        = assert_lib.get_err_fn 'nd.lib.fs'

local as_str        = serialize_lib.as_str
local as_val        = serialize_lib.as_val

local execute       = os.execute

local open          = io.open
local close         = io.close
local popen         = io.popen

local format        = string.format
local gmatch        = string.gmatch
local match         = string.match
local find          = string.find
local sub           = string.sub


local split      = nil
local exists     = nil
local create     = nil
local enum       = nil
local read_file  = nil
local write_file = nil
local read_val   = nil
local write_val  = nil


--- Splits a path to (dirname, filename)
--- @param path string
--- @return string Directory
--- @return string File
split = function(path)
    nd_assert(is_str(path), nd_err, 'split(): path must be of type string')

    local index = find(path, '/?[^/]*$')

    return sub(path, 1, index), sub(path, index + 1, -1)
end

--- Checks whether a directory or file exists
--- @param path string
--- @return boolean
exists = function(path)
    nd_assert(is_str(path), nd_err, 'exists(): path must be of type string')

    local f = open(path, 'rb')

    if f then
        close(f)
    end

    return is_val(f)
end

--- Creates a new directory or file
--- @param path string
create = function(path)
    nd_assert(is_str(path), nd_err, 'create(): path must be of type string')

    nd_assert(execute(format('mkdir -p %s', split(path))), nd_err, 'create(): mkdir -p failed')

    if match(path, '[^/]$') then
        nd_assert(execute(format('echo "" > %s', path)), nd_err, 'create(): echo failed')
    end
end

--- Enumerates entries by a path and filter
--- @param path string
--- @param filter string
--- @return arr<string>
enum = function(path, filter)
    nd_assert(is_str(path) or not path, nd_err, 'enum(): path must be of type string or nil')

    local grep = filter and format('| grep %s', filter)

    local f = nd_assert(popen(format('ls -F %s %s', path or '', grep or '')), nd_err, 'enum(): popen returned nil')

    local arr = {}
    local index = 0

    for s in gmatch(f:read '*a', '[^%s]+') do
        index = index + 1

        arr[index] = s
    end

    close(f)

    return arr
end

--- Reads content of a file by path
--- @param path string
--- @return string
read_file = function(path)
    nd_assert(is_str(path), nd_err, 'read(): path must be of type string')

    local f = nd_assert(open(path), nd_err, 'read(): io.open returned nil')

    local str = f:read '*a'

    close(f)

    return str
end

--- Writes content to a file by path
--- @param path string
--- @param args string|table
write_file = function(path, args)
    nd_assert(is_str(path), nd_err, 'write(): path must be of type string')
    nd_assert(is_str(args) or is_tab(args), nd_err, 'write(): args must be of type string or table')

    create(path)

    local f = nd_assert(open(path, 'w'), nd_err, 'write(): io.open returned nil')

    if is_str(args) then
        f:write(args)
    else
        --- @cast args table
        f:write(unpack(args))
    end

    close(f)
end

--- Reads content of a file by path and returns value
--- @param path string
--- @return any
read_val = function(path)
    nd_assert(is_str(path), nd_err, 'read_val(): path must be of type string')

    return as_val(read_file(path))
end

--- Writes content to a file by path
--- @param path string
--- @param val any
write_val = function(path, val)
    nd_assert(is_str(path), nd_err, 'write_val(): path must be of type string')

    write_file(path, format('return %s', as_str(val) or 'nil'))
end

return {
    split     = split,
    exists    = exists,
    create    = create,
    enum      = enum,
    read      = read_file,
    write     = write_file,
    read_val  = read_val,
    write_val = write_val,
}
