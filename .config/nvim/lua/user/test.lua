local buffer = vim.api.nvim_get_current_buf()
local win_width = vim.api.nvim_win_get_width(0)
local win_height = vim.api.nvim_win_get_height(0)

vim.api.nvim_open_win(buffer, true, {
  relative = 'editor',
  width = win_width / 2,
  height = win_height,
  row = 0,
  col = win_width / 4,
})
