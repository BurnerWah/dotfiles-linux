require'colorizer'.setup {
  'kitty',
  css = {css = true},
  lua = {RGB = false, RRGGBB = true, names = false},
  vim = {RGB = false, RRGGBB = true, names = false},
  zsh = {RGB = true, RRGGBB = true, names = false},
}

local iron = require('iron')

iron.core.add_repl_definitions {
  fennel = {fennel = {command = {"fennel", "--repl"}}},
  fish = {fish = {command = {"fish"}}},
  gluon = {gluon = {command = {"gluon", "-i"}}},
}

iron.core.set_config {
  preferred = {
    fennel = "fennel",
    fish = "fish",
    gluon = "gluon",
    javascript = "node",
    lua = "lua",
    python = "ipython",
    sh = "bash",
    zsh = "zsh",
  },
}

require("navigation")

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = { ['<leader>a'] = '@parameter.inner', },
      swap_prev = { ['<leader>A'] = '@parameter.inner', },
    },
    move = {
      enable = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_star = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
  },
}
