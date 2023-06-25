local format = string.format


local get_name        = nil
local get_bench_cases = nil
local get_test_cases  = nil


get_name = function(scope, fn)
    return format('%s.%s', scope, fn)
end

get_bench_cases = function(scope, fn)
    local empty_fn    = fn.empty
    local range_v_fn  = fn.range_v
    local range_iv_fn = fn.range_iv
    local it_fn       = fn.it
    local iv_fn       = fn.iv
    local kv_fn       = fn.kv
    local keys_fn     = fn.keys
    local ivals_fn    = fn.ivals
    local kvals_fn    = fn.kvals
    local map_fn      = fn.map
    local filter_fn   = fn.filter
    local reduce_fn   = fn.reduce
    local concat_fn   = fn.concat
    local zip_fn      = fn.zip
    local take_fn     = fn.take
    local skip_fn     = fn.skip
    local distinct_fn = fn.distinct
    local group_fn    = fn.group
    local count_fn    = fn.count
    local all_fn      = fn.all
    local any_fn      = fn.any
    local add_fn      = fn.add
    local remove_fn   = fn.remove

    return function()
        return {
            {
                name = get_name(scope, 'empty()'),
                args = {},
                fn = empty_fn,
            },
            {
                name = get_name(scope, 'range_v()'),
                args = { 1024, 0, 3 },
                fn = range_v_fn,
            },
            {
                name = get_name(scope, 'range_iv()'),
                args = { 1024, 0, 3 },
                fn = range_iv_fn,
            },
            {
                name = get_name(scope, 'it()'),
                args = { 1024, 0, 3, ' ', '[^%s]+' },
                fn = it_fn,
            },
            {
                name = get_name(scope, 'iv()'),
                args = { 1024, 0, 3 },
                fn = iv_fn,
            },
            {
                name = get_name(scope, 'kv()'),
                args = { 1024, 0, 3 },
                fn = kv_fn,
            },
            {
                name = get_name(scope, 'keys()'),
                args = { 1024, 0, 3 },
                fn = keys_fn,
            },
            {
                name = get_name(scope, 'ivals()'),
                args = { 1024, 0, 3 },
                fn = ivals_fn,
            },
            {
                name = get_name(scope, 'kvals()'),
                args = { 1024, 0, 3 },
                fn = kvals_fn,
            },
            {
                name = get_name(scope, 'map()'),
                args = { 1024, 0, 3, function(x) return x * x end },
                fn = map_fn,
            },
            {
                name = get_name(scope, 'filter()'),
                args = { 1024, 0, 3, function(x) return x < 2048 end },
                fn = filter_fn,
            },
            {
                name = get_name(scope, 'reduce()'),
                args = { 1024, 0, 3, 0, function(val, x) return val + x end },
                fn = reduce_fn,
            },
            {
                name = get_name(scope, 'concat()'),
                args = { 1024, 0, 3, 1024, 0, 7 },
                fn = concat_fn,
            },
            {
                name = get_name(scope, 'zip()'),
                args = { 1024, 0, 3, 1024, 0, 7 },
                fn = zip_fn,
            },
            {
                name = get_name(scope, 'take()'),
                args = { 1024, 0, 3, 512 },
                fn = take_fn,
            },
            {
                name = get_name(scope, 'skip()'),
                args = { 1024, 0, 3, 512 },
                fn = skip_fn,
            },
            {
                name = get_name(scope, 'distinct()'),
                args = { 1024, 0, 3, function(x) return x end },
                fn = distinct_fn,
            },
            {
                name = get_name(scope, 'group()'),
                args = { 1024, 0, 3, function(x) return x % 2 end },
                fn = group_fn,
            },
            {
                name = get_name(scope, 'count()'),
                args = { 1024, 0, 3 },
                fn = count_fn,
            },
            {
                name = get_name(scope, 'all()'),
                args = { 1024, 0, 3, function(x) return x >= 0 end },
                fn = all_fn,
            },
            {
                name = get_name(scope, 'any()'),
                args = { 1024, 0, 3, function(x) return x < 0 end },
                fn = any_fn,
            },
            {
                name = get_name(scope, 'add()'),
                args = { 1024, 0, 3, 512, -1 },
                fn = add_fn,
            },
            {
                name = get_name(scope, 'remove()'),
                args = { 1024, 0, 3, 512, -1 },
                fn = remove_fn,
            },
        }
    end
end

get_test_cases = function(scope, fn)
    local empty_fn    = fn.empty
    local range_v_fn  = fn.range_v
    local range_iv_fn = fn.range_iv
    local it_fn       = fn.it
    local iv_fn       = fn.iv
    local kv_fn       = fn.kv
    local keys_fn     = fn.keys
    local ivals_fn    = fn.ivals
    local kvals_fn    = fn.kvals
    local map_fn      = fn.map
    local filter_fn   = fn.filter
    local reduce_fn   = fn.reduce
    local concat_fn   = fn.concat
    local zip_fn      = fn.zip
    local take_fn     = fn.take
    local skip_fn     = fn.skip
    local distinct_fn = fn.distinct
    local group_fn    = fn.group
    local count_fn    = fn.count
    local all_fn      = fn.all
    local any_fn      = fn.any
    local add_fn      = fn.add
    local remove_fn   = fn.remove

    return function()
        return {
            {
                name = get_name(scope, 'empty()'),
                args = {},
                res = {},
                fn = empty_fn,
            },
            {
                name = get_name(scope, 'range_v()'),
                args = { 5, 1, 2 },
                res = { 1, 3, 5, 7, 9 },
                fn = range_v_fn,
            },
            {
                name = get_name(scope, 'range_iv()'),
                args = { 5, 1, 2 },
                res = {
                    { 1, 1 },
                    { 2, 3 },
                    { 3, 5 },
                    { 4, 7 },
                    { 5, 9 },
                },
                fn = range_iv_fn,
            },
            {
                name = get_name(scope, 'it()'),
                args = { 4, 1, 3, ' ', '[^%s]+' },
                res = { '1', '4', '7', '10' },
                fn = it_fn,
            },
            {
                name = get_name(scope, 'iv()'),
                args = { 4, 1, 3 },
                res = {
                    { 1, 1 },
                    { 2, 4 },
                    { 3, 7 },
                    { 4, 10 },
                },
                fn = iv_fn,
            },
            {
                name = get_name(scope, 'kv()'),
                args = { 4, 1, 3 },
                res = {
                    { 1, 1 },
                    { 2, 4 },
                    { 3, 7 },
                    { 4, 10 },
                },
                fn = kv_fn,
            },
            {
                name = get_name(scope, 'keys()'),
                args = { 4, 1, 3 },
                res = { 1, 2, 3, 4 },
                fn = keys_fn,
            },
            {
                name = get_name(scope, 'ivals()'),
                args = { 4, 1, 3 },
                res = { 1, 4, 7, 10 },
                fn = ivals_fn,
            },
            {
                name = get_name(scope, 'kvals()'),
                args = { 4, 1, 3 },
                res = { 1, 4, 7, 10 },
                fn = kvals_fn,
            },
            {
                name = get_name(scope, 'map()'),
                args = { 4, 1, 3, function(x) return x * x end },
                res = { 1, 16, 49, 100 },
                fn = map_fn,
            },
            {
                name = get_name(scope, 'filter()'),
                args = { 4, 1, 3, function(x) return x < 6 end },
                res = { 1, 4 },
                fn = filter_fn,
            },
            {
                name = get_name(scope, 'reduce()'),
                args = { 4, 1, 3, 0, function(val, x) return val + x end },
                res = 22,
                fn = reduce_fn,
            },
            {
                name = get_name(scope, 'concat()'),
                args = { 4, 1, 3, 4, 1, 7 },
                res = { 1, 4, 7, 10, 1, 8, 15, 22 },
                fn = concat_fn,
            },
            {
                name = get_name(scope, 'zip()'),
                args = { 4, 1, 3, 4, 1, 7 },
                res = {
                    { 1,  1 },
                    { 4,  8 },
                    { 7,  15 },
                    { 10, 22 },
                },
                fn = zip_fn,
            },
            {
                name = get_name(scope, 'take()'),
                args = { 4, 1, 3, 2 },
                res = { 1, 4 },
                fn = take_fn,
            },
            {
                name = get_name(scope, 'skip()'),
                args = { 4, 1, 3, 2 },
                res = { 7, 10 },
                fn = skip_fn,
            },
            {
                name = get_name(scope, 'distinct()'),
                args = { 4, 1, 3, function(x) return x end },
                res = { 1, 4, 7, 10 },
                fn = distinct_fn,
            },
            {
                name = get_name(scope, 'group()'),
                args = { 4, 1, 3, function(x) return x % 2 end },
                res = {
                    [0] = { 4, 10 },
                    [1] = { 1, 7 },
                },
                fn = group_fn,
            },
            {
                name = get_name(scope, 'count()'),
                args = { 4, 1, 3 },
                res = 4,
                fn = count_fn,
            },
            {
                name = get_name(scope, 'all()'),
                args = { 4, 1, 3, function(x) return x > 0 end },
                res = true,
                fn = all_fn,
            },
            {
                name = get_name(scope, 'any()'),
                args = { 4, 1, 3, function(x) return x < 0 end },
                res = false,
                fn = any_fn,
            },
            {
                name = get_name(scope, 'add()'),
                args = { 4, 1, 3, 3, 6 },
                res = { 1, 4, 6, 7, 10 },
                fn = add_fn,
            },
            {
                name = get_name(scope, 'remove()'),
                args = { 4, 1, 3, 3 },
                res = { 1, 4, 10 },
                fn = remove_fn,
            },
        }
    end
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
