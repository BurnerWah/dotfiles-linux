local iron = require("iron").core

-- Add extra REPLs
iron.add_repl_definitions({
  fish = { fish = { command = { "fish" } } },
  gluon = { gluon = { command = { "gluon", "-i" } } },
  lua = { croissant = { command = { "croissant" } } },
})

iron.set_config({
  preferred = {
    fennel = "fennel",
    fish = "fish",
    gluon = "gluon",
    javascript = "node",
    lua = "lua", --[[croissant doesn't seem to work unfortunately]]
    python = "ipython",
    sh = "bash",
    zsh = "zsh",
  },
})

-- Set up keymaps that aren't useful until iron starts
vim.keymap.nmap({ "cst", "<Plug>(iron-interrupt)" })
vim.keymap.nmap({ "cq", "<Plug>(iron-exit)" })
vim.keymap.nmap({ "cl", "<Plug>(iron-clear)" })
vim.keymap.nmap({ "cp", "<Plug>(iron-repeat-cmd)" })
vim.keymap.nmap({ "c<CR>", "<Plug>(iron-cr)" })
