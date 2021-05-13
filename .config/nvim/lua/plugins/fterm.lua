require('FTerm').setup()

local term = require("FTerm.terminal")

user_terminals = {bpytop = term:new():setup({cmd = "bpytop"})}

vim.cmd [[command! Bpytop lua user_terminals.bpytop:toggle()]]
