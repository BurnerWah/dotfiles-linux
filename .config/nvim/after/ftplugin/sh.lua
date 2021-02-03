-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

if (packer_plugins['lspsaga.nvim'] and packer_plugins['lspsaga.nvim'].loaded) then
  vim.keymap.nnoremap { 'K', require('lspsaga.hover').render_hover_doc, buffer = true, silent = true }
end
