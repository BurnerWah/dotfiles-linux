vim.bo.tabstop = 2

if vim.g.did_coc_loaded then
  vim.bo.formatexpr = [[CocAction('formatSelected')]]
  vim.keymap.nnoremap { 'K', [[<cmd>call CocActionAsync('doHover')<cr>]], buffer = true, silent = true }
end
