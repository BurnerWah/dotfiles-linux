local M = {}

local fileformat_icons = {unix = '', dos = '', mac = ''}

function M.fileformat() return fileformat_icons[vim.bo.fileformat] end

return M
