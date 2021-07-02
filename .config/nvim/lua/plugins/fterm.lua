require('FTerm').setup()

local Terminal = require("FTerm.terminal")

user_terminals = {bpytop = Terminal:new():setup({cmd = "bpytop"})}

vim.cmd('command! Bpytop lua user_terminals.bpytop:toggle()')
