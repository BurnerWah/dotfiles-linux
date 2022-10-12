local filetype = require("plenary.filetype")
local V = require("vlib")
local expand = V.fn.expand
local did_filetype = V.fn.did_filetype

local M = {}

function M.detect_ft()
  if not did_filetype() then
    local file = expand("<amatch>")
    if not file then
      return
    end
    local ft = filetype.detect(file)
    if ft ~= "" then
      vim.bo.filetype = ft
      -- vim.cmd("setfiletype " .. ft)
    end
  end
end

return M
