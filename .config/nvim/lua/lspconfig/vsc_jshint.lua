local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'vsc_jshint'
local root_pattern = util.root_pattern('.jshintrc', 'package.json')

configs[server_name] = {
  default_config = {
    cmd = {
      'node',
      vim.fn.expand('~/.local/libexec/vscode-ext/vscode-jshint/jshint-server/out/server.js'),
      '--stdio',
    },
    filetypes = {'javascript', 'javascriptreact', 'html'},
    root_dir = root_pattern,
  },
}
