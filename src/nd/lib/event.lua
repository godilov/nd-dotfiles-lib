local fn_lib     = require 'nd.lib.core.fn'
local type_lib   = require 'nd.lib.core.type'
local assert_lib = require 'nd.lib.core.assert'

local nd_assert  = assert_lib.get_fn(ND_LIB_IS_DEBUG)
local nd_err     = assert_lib.get_err_fn 'nd.lib.event'

local ivals      = fn_lib.ivals
local each       = fn_lib.each

local is_str     = type_lib.is_str
local is_fn      = type_lib.is_fn

local format     = string.format


local events      = {}
local key         = nil
local subscribe   = nil
local notify_each = nil
local notify      = nil


key = function(scope, name)
    return format('%s.%s', scope, name)
end

--- Subscribes for an event ("{scope}.{name}")
--- @param scope string
--- @param name string
--- @param fn function
subscribe = function(scope, name, fn)
    nd_assert(is_str(scope), nd_err, 'subscribe(): scope must be of type string')
    nd_assert(is_str(name), nd_err, 'subscribe(): name must be of type string')
    nd_assert(is_fn(fn), nd_err, 'subscribe(): fn must be of type function')

    local k = key(scope, name)

    local event = events[k]

    if not event then
        events[k] = {}
    end

    event[#event + 1] = fn
end

--- Notifies of an event ("{scope}.{name}") with call of a function
--- @param args any
--- @return function
notify_each = function(args)
    return function(fn)
        fn(args)
    end
end

--- Notifies of an event ("{scope}.{name}") occured
--- @param scope string
--- @param name string
notify = function(scope, name, args)
    nd_assert(is_str(scope), nd_err, 'notify(): scope must be of type string')
    nd_assert(is_str(name), nd_err, 'notify(): name must be of type string')

    local event = events[key(scope, name)]

    if event then
        each(notify_each(args), ivals(event))
    end
end

return {
    subscribe = subscribe,
    notify    = notify,
}
