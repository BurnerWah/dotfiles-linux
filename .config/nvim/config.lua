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
  gluon = {
    gluon = {
      command = {"gluon", "-i"}
    }
  }
}

iron.core.set_config {
  preferred = {
    fennel = "fennel",
    gluon = "gluon",
    python = "ipython"
  }
}
