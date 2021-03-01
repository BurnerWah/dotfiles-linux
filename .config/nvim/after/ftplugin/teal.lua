-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.tabstop = 2

-- matchit
if vim.g.loaded_matchit then
  vim.b.match_ignorecase = 0
  vim.b.match_words = table.concat {
    [[\<\%(do\|enum\|record\|function\|if\)\>:]], [[\<\%(return\|else\|elseif\)\>:]], [[\<end\>,]],
    [[\<repeat\>:\<until\>]],
  }
end

-- endwise
if vim.g.loaded_endwise then
  vim.b.endwise_addition = 'end'
  vim.b.endwise_words = 'function,do,then,enum,record'
  vim.b.endwise_pattern = [[\zs\<\%(then\|do\)\|\(\%(function\|record\|enum\).*\)\ze\s*$]]
  vim.b.endwise_groups = 'tealFunction,tealDoEnd,tealIfStatement,tealRecord,tealEnum'
end
