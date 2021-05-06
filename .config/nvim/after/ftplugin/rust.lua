vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.bo.tabstop = 4

vim.wo.signcolumn = 'yes'

local nnor, vnor = vim.keymap.nnoremap, vim.keymap.vnoremap
nnor {'gJ', [[<Cmd>RustJoinLines<CR>]], silent = true, buffer = true}
nnor {'K', [[<Cmd>RustHoverActions<CR>]], silent = true, buffer = true}
nnor {'ca', [[<Cmd>Lspsaga code_action<CR>]], silent = true, buffer = true}
vnor {'ca', [[:<C-u>Lspsaga range_code_action<CR>]], silent = true, buffer = true}
nnor {'[e', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true}
nnor {']e', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true}
nnor {'<Leader>rn', [[<Cmd>Lspsaga rename<CR>]], silent = true, buffer = true}
