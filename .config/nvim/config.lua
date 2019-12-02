require 'colorizer'.setup {
  'kitty';
  css = { css = true; };
  vim = { RGB = false; RRGGBB = true; names = false; };
  zsh = { RGB = true;  RRGGBB = true; names = false; };
}

local iron = require('iron')

iron.core.add_repl_definitions {
  fennel = {
    fennel = {
      command = {"fennel", "--repl"}
    }
  },
  fish = {
    fish = {
      command = {"fish"}
    }
  },
  gluon = {
    gluon = {
      command = {"gluon", "-i"}
    }
  }
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
    zsh = "zsh"
  }
}
