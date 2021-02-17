-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.tabstop = 2

vim.cmd [[autocmd! user_ftplugin * <buffer>]]

if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.bo.formatexpr = [[CocAction('formatSelected')]]
end
