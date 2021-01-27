vim.cmd [[autocmd! user_ftplugin * <buffer>]]

if vim.g.did_coc_loaded then
  vim.cmd [[autocmd user_ftplugin CursorHold <buffer> silent call CocActionAsync('highlight')]]
end
