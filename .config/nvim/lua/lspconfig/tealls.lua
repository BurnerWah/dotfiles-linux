local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'tealls'

configs[server_name] = {
  default_config = {
    cmd = {
      'teal-language-server',
      -- "logging=on", use this to enable logging in /tmp/teal-language-server.log
    },
    filetypes = {'teal'},
    root_dir = util.root_pattern('tlconfig.lua', '.git'),
    settings = {},
  },
}
