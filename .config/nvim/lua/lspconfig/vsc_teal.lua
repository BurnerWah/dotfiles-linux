local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'vsc_teal'

configs[server_name] = {
  default_config = {
    cmd = {
      'node', vim.fn.expand('~/.local/libexec/vscode-ext/vscode-teal/out/server/server.js'),
      '--stdio',
    },
    filetypes = {'teal'},
    root_dir = function(fname) return util.find_git_ancestor(fname) or util.path.dirname(fname) end,
  },
}
