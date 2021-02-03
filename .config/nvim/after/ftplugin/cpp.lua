-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.tabstop = 2

if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.bo.formatexpr = [[CocAction('formatSelected')]]
  vim.keymap.nmap { 'gD', '<plug>(coc-definition)', buffer = true, silent = true }
end

if (packer_plugins['lspsaga.nvim'] and packer_plugins['lspsaga.nvim'].loaded) then
  vim.keymap.nnoremap { 'K', require('lspsaga.hover').render_hover_doc, buffer = true, silent = true }
end
