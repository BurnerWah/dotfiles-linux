-- luacheck: std +luacheckrc
-- Allow us to require files from the lua subdirectory
-- Fails if XDG_CONFIG_HOME isn't set
package.path = os.getenv('XDG_CONFIG_HOME') .. '/luacheck/lua/?.lua;' .. package.path

-- Just require in any custom std libs
stds.nvim = require('std_nvim')
stds.rocksconfig = require('std_rocksconfig')

-- Builtin files
files['**/spec/**/*_spec.lua'].std = '+busted'
files['**/test/**/*_spec.lua'].std = '+busted'
files['**/tests/**/*_spec.lua'].std = '+busted'
files['**/*.rockspec'].std = '+rockspec'
files['**/*.luacheckrc'].std = '+luacheckrc'

-- Custom custom files
files['**/luarocks/config-*.lua'].std = '+rocksconfig'
files['**/nvim/**/*.lua'].std = 'luajit+nvim'

-- These are handled better by the sumneko language server
files['**/*.lua'].ignore = {'[2346]', '5[24]'}
-- vim:ft=lua
