local color_lib = require 'nd.lib.core.color'

local rgb       = color_lib.rgb
local hsl       = color_lib.hsl
local hsb       = color_lib.hsb

local is_rgb    = color_lib.is_rgb
local is_hsl    = color_lib.is_hsl
local is_hsb    = color_lib.is_hsb

local rgb_from  = rgb.from
local rgb_add   = rgb.add
local rgb_sub   = rgb.sub
local rgb_mul   = rgb.mul
local rgb_div   = rgb.div

local hsl_from  = hsl.from
local hsl_add   = hsl.add
local hsl_sub   = hsl.sub
local hsl_mul   = hsl.mul
local hsl_div   = hsl.div

local hsb_from  = hsb.from
local hsb_add   = hsb.add
local hsb_sub   = hsb.sub
local hsb_mul   = hsb.mul
local hsb_div   = hsb.div


local is_rgb_fn = function(args) return is_rgb(rgb_from(args[1])) end
local is_hsl_fn = function(args) return is_hsl(hsl_from(args[1])) end
local is_hsb_fn = function(args) return is_hsb(hsb_from(args[1])) end


local rgb_add_color_fn = function(args) return rgb_add(rgb_from(args[1]), rgb_from(args[2])) end
local rgb_sub_color_fn = function(args) return rgb_sub(rgb_from(args[1]), rgb_from(args[2])) end
local rgb_mul_color_fn = function(args) return rgb_mul(rgb_from(args[1]), rgb_from(args[2])) end
local rgb_div_color_fn = function(args) return rgb_div(rgb_from(args[1]), rgb_from(args[2])) end

local hsl_add_color_fn = function(args) return hsl_add(hsl_from(args[1]), hsl_from(args[2])) end
local hsl_sub_color_fn = function(args) return hsl_sub(hsl_from(args[1]), hsl_from(args[2])) end
local hsl_mul_color_fn = function(args) return hsl_mul(hsl_from(args[1]), hsl_from(args[2])) end
local hsl_div_color_fn = function(args) return hsl_div(hsl_from(args[1]), hsl_from(args[2])) end

local hsb_add_color_fn = function(args) return hsb_add(hsb_from(args[1]), hsb_from(args[2])) end
local hsb_sub_color_fn = function(args) return hsb_sub(hsb_from(args[1]), hsb_from(args[2])) end
local hsb_mul_color_fn = function(args) return hsb_mul(hsb_from(args[1]), hsb_from(args[2])) end
local hsb_div_color_fn = function(args) return hsb_div(hsb_from(args[1]), hsb_from(args[2])) end


local rgb_add_number_fn = function(args) return rgb_add(rgb_from(args[1]), args[2]) end
local rgb_sub_number_fn = function(args) return rgb_sub(rgb_from(args[1]), args[2]) end
local rgb_mul_number_fn = function(args) return rgb_mul(rgb_from(args[1]), args[2]) end
local rgb_div_number_fn = function(args) return rgb_div(rgb_from(args[1]), args[2]) end

local hsl_add_number_fn = function(args) return hsl_add(hsl_from(args[1]), args[2]) end
local hsl_sub_number_fn = function(args) return hsl_sub(hsl_from(args[1]), args[2]) end
local hsl_mul_number_fn = function(args) return hsl_mul(hsl_from(args[1]), args[2]) end
local hsl_div_number_fn = function(args) return hsl_div(hsl_from(args[1]), args[2]) end

local hsb_add_number_fn = function(args) return hsb_add(hsb_from(args[1]), args[2]) end
local hsb_sub_number_fn = function(args) return hsb_sub(hsb_from(args[1]), args[2]) end
local hsb_mul_number_fn = function(args) return hsb_mul(hsb_from(args[1]), args[2]) end
local hsb_div_number_fn = function(args) return hsb_div(hsb_from(args[1]), args[2]) end


local color_eq        = nil

local get_bench_cases = nil
local get_test_cases  = nil


color_eq = function(x, y)
    return x.data[0] == y[1] and
        x.data[1] == y[2] and
        x.data[2] == y[3] and
        x.data[3] == y[4]
end

get_bench_cases = function()
    return {
    }
end

get_test_cases = function()
    return {
        {
            name = 'color.is_rgb()',
            args = { 0 },
            res = true,
            fn = is_rgb_fn,
        },
        {
            name = 'color.is_hsl()',
            args = { 0.0 },
            res = true,
            fn = is_hsl_fn,
        },
        {
            name = 'color.is_hsb()',
            args = { 0.0 },
            res = true,
            fn = is_hsb_fn,
        },
        {
            name = 'rgb.from()',
            args = { 0, 0, 0, 0 },
            res = { 0, 0, 0, 0 },
            fn = rgb_from,
            is_ok = color_eq,
        },
        {
            name = 'rgb.from()',
            args = { 255, 255, 255, 255 },
            res = { 255, 255, 255, 255 },
            fn = rgb_from,
            is_ok = color_eq,
        },
        {
            name = 'rgb.add(): color',
            args = { 128, 127 },
            res = { 255, 255, 255, 255 },
            fn = rgb_add_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'rgb.sub(): color',
            args = { 255, 127 },
            res = { 128, 128, 128, 128 },
            fn = rgb_sub_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'rgb.mul(): color',
            args = { 64, 2 },
            res = { 128, 128, 128, 128 },
            fn = rgb_mul_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'rgb.div(): color',
            args = { 128, 2 },
            res = { 64, 64, 64, 64 },
            fn = rgb_div_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'rgb.add(): number',
            args = { 128, 127 },
            res = { 255, 255, 255, 255 },
            fn = rgb_add_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'rgb.sub(): number',
            args = { 255, 127 },
            res = { 128, 128, 128, 128 },
            fn = rgb_sub_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'rgb.mul(): number',
            args = { 64, 2 },
            res = { 128, 128, 128, 128 },
            fn = rgb_mul_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'rgb.div(): number',
            args = { 128, 2 },
            res = { 64, 64, 64, 64 },
            fn = rgb_div_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.from()',
            args = { 0.0, 0.0, 0.0, 0.0 },
            res = { 0.0, 0.0, 0.0, 0.0 },
            fn = hsl_from,
            is_ok = color_eq,
        },
        {
            name = 'hsl.from()',
            args = { 1.0, 1.0, 1.0, 1.0 },
            res = { 1.0, 1.0, 1.0, 1.0 },
            fn = hsl_from,
            is_ok = color_eq,
        },
        {
            name = 'hsl.add(): color',
            args = { 0.5, 0.25 },
            res = { 0.75, 0.75, 0.75, 0.75 },
            fn = hsl_add_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.sub(): color',
            args = { 0.5, 0.25 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsl_sub_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.mul(): color',
            args = { 0.5, 0.5 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsl_mul_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.div(): color',
            args = { 0.5, 0.5 },
            res = { 1.0, 1.0, 1.0, 1.0 },
            fn = hsl_div_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.add(): number',
            args = { 0.5, 0.25 },
            res = { 0.75, 0.75, 0.75, 0.75 },
            fn = hsl_add_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.sub(): number',
            args = { 0.5, 0.25 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsl_sub_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.mul(): number',
            args = { 0.5, 0.5 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsl_mul_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsl.div(): number',
            args = { 0.5, 2 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsl_div_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.from()',
            args = { 0.0, 0.0, 0.0, 0.0 },
            res = { 0.0, 0.0, 0.0, 0.0 },
            fn = hsb_from,
            is_ok = color_eq,
        },
        {
            name = 'hsb.from()',
            args = { 1.0, 1.0, 1.0, 1.0 },
            res = { 1.0, 1.0, 1.0, 1.0 },
            fn = hsb_from,
            is_ok = color_eq,
        },
        {
            name = 'hsb.add(): color',
            args = { 0.5, 0.25 },
            res = { 0.75, 0.75, 0.75, 0.75 },
            fn = hsb_add_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.sub(): color',
            args = { 0.5, 0.25 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsb_sub_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.mul(): color',
            args = { 0.5, 0.5 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsb_mul_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.div(): color',
            args = { 0.5, 0.5 },
            res = { 1.0, 1.0, 1.0, 1.0 },
            fn = hsb_div_color_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.add(): number',
            args = { 0.5, 0.25 },
            res = { 0.75, 0.75, 0.75, 0.75 },
            fn = hsb_add_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.sub(): number',
            args = { 0.5, 0.25 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsb_sub_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.mul(): number',
            args = { 0.5, 0.5 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsb_mul_number_fn,
            is_ok = color_eq,
        },
        {
            name = 'hsb.div(): number',
            args = { 0.5, 2 },
            res = { 0.25, 0.25, 0.25, 0.25 },
            fn = hsb_div_number_fn,
            is_ok = color_eq,
        },
    }
end

return {
    get_bench_cases = get_bench_cases,
    get_test_cases  = get_test_cases,
}
