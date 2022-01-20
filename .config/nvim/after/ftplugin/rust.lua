vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

vim.bo.tabstop = 4

vim.wo.signcolumn = "yes"

vim.keymap.set("n", "gJ", [[<Cmd>RustJoinLines<CR>]], { noremap = true, silent = true, buffer = true })
vim.keymap.set("n", "K", [[<Cmd>RustHoverActions<CR>]], { noremap = true, silent = true, buffer = true })
vim.keymap.set("n", "ca", [[<Cmd>Lspsaga code_action<CR>]], { noremap = true, silent = true, buffer = true })
vim.keymap.set("v", "ca", [[:<C-u>Lspsaga range_code_action<CR>]], { noremap = true, silent = true, buffer = true })
vim.keymap.set("n", "[e", [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], { noremap = true, silent = true, buffer = true })
vim.keymap.set("n", "]e", [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], { noremap = true, silent = true, buffer = true })
vim.keymap.set("n", "<Leader>rn", [[<Cmd>Lspsaga rename<CR>]], { noremap = true, silent = true, buffer = true })
