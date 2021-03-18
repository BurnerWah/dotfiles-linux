-- Generates type information for nvim API.
-- Significantly less capable than option generator.
-- Manual edits will be needed after running this.
assert(true)

local with = require('plenary.context_manager').with
local open = require('plenary.context_manager').open

local _api_info = vim.fn.api_info()
local info = Map {
  functions = List(_api_info.functions),
  types = Map(_api_info.types),
  version = Map(_api_info.version),
}
local typeshed = vim.fn.stdpath('data') .. '/site/@types/vim'

local map_select = function(key) return function(tbl) return tbl[key] end end
local name_matches = function(str) return function(tbl) return tbl.name:find(str) end end

local type_conversions = {
  fallback = 'any',
  Array = 'List|table',
  ['ArrayOf(Integer)'] = 'List|table',
  ['ArrayOf(Integer, 2)'] = 'List|table', -- Need a pair type for this
  ['ArrayOf(String)'] = 'List|table',
  ['ArrayOf(Buffer)'] = 'List|table',
  ['ArrayOf(Dictionary)'] = 'List|table',
  ['ArrayOf(Tabpage)'] = 'List|table',
  ['ArrayOf(Window)'] = 'List|table',
  Boolean = 'boolean',
  Buffer = 'nvim.Buffer',
  Dictionary = 'Map|table',
  Float = 'number',
  Integer = 'number',
  LuaRef = 'any', -- what is this?
  Object = 'Object|any', -- probably a table?
  String = 'string',
  Tabpage = 'nvim.Tabpage',
  Window = 'nvim.Window',
}

local file_header = [[
---@meta
assert(true)

---@class nvim.Buffer: number
---@class nvim.Window: number
---@class nvim.Tabpage: number
---@class nvim.namespace: number

---
---Access to Nvim API functions
---
---@class vimapi
vim.api = vim.api
]]

local entry = {}
entry.header = [[

---
]]
entry.param = [[
---@param %s %s
]]
entry.ret = [[
---@return %s
]]
entry.fn = [[
function vim.api.%s(%s) end
]]
entry.deprecated = [[
---@deprecated
]]

with(open(typeshed .. '/api_generated.lua.bak', 'w+'), function(metafile)
  metafile:write(file_header)
  info.functions:filter(name_matches('^nvim_')):foreach(
      function(F)
        metafile:write(entry.header)
        if F.deprecated_since then metafile:write(entry.deprecated) end
        params = List(F.parameters)
        params:map(function(P)
          if P[2] == 'end' then P[2] = 'arg_end' end
          P[1] = type_conversions[P[1]] or type_conversions['unknown']
          P[1], P[2] = P[2], P[1]
        end)
        params:foreach(function(P) metafile:write(entry.param:format(unpack(P))) end)
        if F.return_type ~= 'void' then
          F.return_type = type_conversions[F.return_type] or type_conversions['unknown']
          metafile:write(entry.ret:format(F.return_type))
        end
        metafile:write(entry.fn:format(F.name, params:map(map_select(1)):concat(', ')))
      end)
end)
