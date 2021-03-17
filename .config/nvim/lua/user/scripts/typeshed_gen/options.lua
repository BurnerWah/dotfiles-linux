-- Generates full type information from options.lua (from neovim source code)
-- Assumes penlight is globally imported
assert(true)

local with = require('plenary.context_manager').with
local open = require('plenary.context_manager').open

local options = List(require('temp-nvim-options-extracted').options)
local types = vim.fn.stdpath('data') .. '/site/@types/vim'

local header = [[
---@meta
assert(true)
--
-- Note: this is generated based on vim's options.lua
---
---@class vim.opt.%s
---
]]
local field = [[
---@field %s %s%s
]]

local filter_scope = function(scope)
  return function(option) return vim.tbl_contains(option.scope, scope) end
end
local format_opt = function(opt)
  local T = (opt.type == 'bool') and 'boolean' or opt.type
  local D = ''
  if opt.short_desc then
    D = opt.short_desc():gsub([[^N_%("]], ' '):gsub([["%)$]], ''):gsub([[\"]], '"')
  end
  local R = field:format(opt.full_name, T, D)
  if opt.abbreviation then R = R .. field:format(opt.abbreviation, T, D) end
  return R
end

with(open(types .. '/bo.lua', 'w+'), function(F)
  F:write(header:format('buffer'))
  options:filter(filter_scope('buffer')):foreach(function(O) F:write(format_opt(O)) end)
  F:write('vim.bo = vim.bo')
end)

with(open(types .. '/wo.lua', 'w+'), function(F)
  F:write(header:format('window'))
  options:filter(filter_scope('window')):foreach(function(O) F:write(format_opt(O)) end)
  F:write('vim.wo = vim.wo')
end)

with(open(types .. '/o.lua', 'w+'), function(F)
  F:write(header:format('global'))
  options:foreach(function(O) F:write(format_opt(O)) end)
  F:write('vim.o = vim.o')
end)
