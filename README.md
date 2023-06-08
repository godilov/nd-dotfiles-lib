# nd-dotfiles-lib

Fast and reliable Lua library.  
Designed to be used as source code without any additional tools or package managers.

## Requirements

- Linux
- LuaJIT

Module [filesystem](src/nd/lib/fs.lua) depends on Linux-specific commands (such as `ls`, `grep`, `mkdir` and `echo`), so it should not work on Windows currently.  
Modules [color](src/nd/lib/core/color.lua) and [stopwatch](src/nd/lib/core/sw.lua) depends on LuaJIT-specific features (FFI, to be exact), so only the JIT version is supported.

## Usage

To include the library, simply place its source code somewhere in your working tree and then call `init()` function from [init](src/init.lua) module.  
The function takes 2 arguments:
- `root`: path (relative or absolute) to your working directory. Default: `'.'`
- `is_debug`: flag whether the library in debug mode for error assertion. Used only for assertion. Default: `false`

Since applied modules (such as [fn](src/nd/lib/core/fn.lua), [color](src/nd/lib/core/color.lua), ...) depends on secondary ([type](src/nd/lib/core/type.lua), [assert](src/nd/lib/core/assert.lua), ...) and can be reused as source code, `init()` must add path to the library in `package.path` for ability to call `require()`.  
  
After `init()` you can easily call `require 'nd.lib.core.(module)'` for core module or `require 'nd.lib.(module)'` for stateful module.

## Philosophy

The library was created to fulfill basic software requirements:
- Fast and functional iterators (like Rust std::iter, C++ std::ranges or C# LINQ)
- Color processing (mainly for [Awesome WM](https://github.com/GermanOdilov/nd-dotfiles-awesome) and [Nvim](https://github.com/GermanOdilov/nd-dotfiles-nvim) configs)
- Testing and benchmarking facilities
- Caching
- Serialization
- Strings extra functionality
- Tables extra functionality

For reliability and convenience purposes, almost whole library is written in Functional paradigm without any state mutation and other dirty (~~OOP~~) things.  
Only specific stateful-by-definition things like IO, cache, etc. is allowed to be non-functional.

## Structure

The library is separated in 2 main components by simple criteria:

- `nd.lib.core`: core modules written purely in functional paradigm. Disallowed to call `nd.lib` modules
- `nd.lib`: modules which uses some external state (like IO) or creates it. Allowed to call `nd.lib.core` modules

The main goal here is to maximize `nd.lib.core` and minimize `nd.lib`.

