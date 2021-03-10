vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.bo.comments = ':#'
vim.bo.commentstring = '# %s'
local iskeyword = require('user.optlib').commalist('iskeyword', 'bo')
iskeyword = iskeyword + {'$', '@-@'}
vim.bo.indentkeys = '0{,0},0),0[,0],0#,!^F,o,O'

vim.b.did_indent = 1
