-- Generated completion data for standard vim functions.
-- Uses eval.lua from nvim source code.
-- The resulting file requires A LOT of manual edits.
-- This is just to generate baseline data which can then be turned into a typeshed.
assert(true)

local with = require('plenary.context_manager').with
local open = require('plenary.context_manager').open

local funcs = List(vim.tbl_keys(require('temp-nvim-eval-extracted').funcs))
local types = vim.fn.stdpath('data') .. '/site/@types/vim'

local file_header = [[
---@meta
assert(true)

---@class vim.channel: number
---@class vim.job: vim.channel

---
---Access vim functions
---
---@class vimfn
vim.fn = vim.fn
]]
local entry = [[

---
function vim.fn['%s'](...) end
]]

with(open(types .. '/fn_generated.lua', 'w+'), function(F)
  F:write(file_header)
  funcs:sorted():foreach(function(K) F:write(entry:format(K)) end)
end)
