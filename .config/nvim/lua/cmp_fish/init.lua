local cmp = require('cmp')
local uv = require('luv')
local Job = require('plenary.job')

local Source = {}

function Source.new()
  local self = setmetatable({}, {__index = Source})
  self.has_fish = vim.fn.executable('fish') == 1
  return self
end

function Source.is_available() return vim.bo.filetype == 'fish' end

function Source.get_keyword_pattern() return [[\S\+]] end

function Source:complete(request, callback) local results = {} end

return Source
