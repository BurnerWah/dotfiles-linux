local iron = require('iron').core

-- Add extra REPLs
iron.add_repl_definitions {
  fish = {fish = {command = {'fish'}}},
  gluon = {gluon = {command = {'gluon', '-i'}}},
  lua = {croissant = {command = {'croissant'}}},
}

iron.set_config {
  preferred = {
    fennel = 'fennel',
    fish = 'fish',
    gluon = 'gluon',
    javascript = 'node',
    lua = 'croissant',
    python = 'ipython',
    sh = 'bash',
    zsh = 'zsh',
  },
}
