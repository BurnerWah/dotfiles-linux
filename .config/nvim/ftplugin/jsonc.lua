vim.bo.commentstring = '//%s'
vim.bo.comments = 's1:/*,mb:*,ex:*/,://'

vim.cmd [[setl formatoptions-=t]]

-- Use tree-sitter to handle folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.tabstop = 2
