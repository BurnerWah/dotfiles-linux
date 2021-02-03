-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.tabstop = 2

if (packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  vim.bo.formatexpr = [[CocAction('formatSelected')]]
  vim.cmd [[command! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')]]
end

if (packer_plugins['lspsaga.nvim'] and packer_plugins['lspsaga.nvim'].loaded) then
  vim.keymap.nnoremap { 'K', require('lspsaga.hover').render_hover_doc, buffer = true, silent = true }
end
