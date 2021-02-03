-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.tabstop = 2

vim.cmd [[autocmd! user_ftplugin * <buffer>]]

if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.keymap.nmap { 'gD', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nmap { '<C-]>', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nmap { '<C-LeftMouse> <LeftMouse>', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.keymap.nmap { 'g<LeftMouse> <LeftMouse>', '<plug>(coc-definition)', buffer = true, silent = true }
  vim.cmd [[autocmd user_ftplugin BufWritePre <buffer> call CocAction('runCommand', 'editor.action.organizeImport')]]
end

if (packer_plugins['lspsaga.nvim'] and packer_plugins['lspsaga.nvim'].loaded) then
  vim.keymap.nnoremap { 'K', require('lspsaga.hover').render_hover_doc, buffer = true, silent = true }
end
