-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 0

vim.bo.tabstop = 2

if vim.g.loaded_endwise then
  vim.b.endwise_addition = 'end'
  vim.b.endwise_words = 'function,do,then'
  vim.b.endwise_pattern = [[\zs\%(\<function\>\)\%(.*\<end\>\)\@!\|\<\%(then\|do\)\ze\s*$]]
  vim.b.endwise_syngroups = 'luaFunction,luaDoEnd,luaIfStatement'
end
