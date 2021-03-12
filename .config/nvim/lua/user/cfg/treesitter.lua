require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {enable = true},
  incremental_selection = {enable = true},
  indent = {enable = true}, -- Indent uses 'tabstop' so it has to be managed in ftplugins.
  playground = {enable = true},
  refactor = {highlight_definitions = {enable = true}, smart_rename = {enable = true}},
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ["a'"] = {lua = '@string.outer'},
        ['a`'] = {lua = '@string.outer'},
        ['a"'] = {lua = '@string.outer'},
      },
    },
  },
  autotag = {enable = true},
}
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.bash.used_by = {'PKGBUILD'}
