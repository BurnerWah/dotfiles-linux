vim.cmd [[autocmd! user_ftplugin * <buffer>]]

if vim.g.did_coc_loaded then
  vim.keymap.nmap { 'gD', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nnoremap { 'K', [[<cmd>call CocActionAsync('doHover')<cr>]], buffer = true, silent = true }
  vim.cmd [[autocmd user_ftplugin CursorHold <buffer> silent call CocActionAsync('highlight')]]
end
