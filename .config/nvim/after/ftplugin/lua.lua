-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 0

vim.bo.tabstop = 2

if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.keymap.nmap {'gD', '<plug>(coc-definition)', buffer = true, silent = true}
end
