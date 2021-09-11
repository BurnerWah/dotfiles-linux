local Terminal = require("FTerm")

user_terminals = {bpytop = Terminal:new({cmd = "bpytop"})}

vim.cmd('command! Bpytop lua user_terminals.bpytop:toggle()')
