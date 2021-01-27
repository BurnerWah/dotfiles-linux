-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.cmd [[autocmd! user_ftplugin * <buffer>]]

if vim.g.did_coc_loaded then
  vim.keymap.nmap { 'gD', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nmap { '<C-]>', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nmap { '<C-LeftMouse> <LeftMouse>', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nmap { 'g<LeftMouse> <LeftMouse>', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nnoremap { 'K', [[<cmd>call CocActionAsync('doHover')<cr>]], buffer = true, silent = true }
  vim.cmd [[autocmd user_ftplugin BufWritePre <buffer> call CocAction('runCommand', 'editor.action.organizeImport')]]
  vim.cmd [[autocmd user_ftplugin CursorHold <buffer> silent call CocActionAsync('highlight')]]
end