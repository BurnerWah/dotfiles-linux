local filetype = require 'plenary.filetype'
local expand = vim.fn.expand
local did_filetype = vim.fn.did_filetype

local M = {}

M.detect_ft = function()
  if did_filetype() == 0 then
    local file = expand '<amatch>'
    local type = filetype.detect(file)
    if type ~= '' then
      vim.bo.filetype = type
    end
  end
end

return M
