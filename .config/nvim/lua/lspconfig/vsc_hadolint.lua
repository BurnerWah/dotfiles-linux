local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'vsc_hadolint'

-- This is very loud as, the only security it has is error.
configs[server_name] = {
  default_config = {
    cmd = {
      'node', vim.fn.expand('~/.local/libexec/vscode-ext/vscode-hadolint/server/out/server.js'),
      '--stdio',
    },
    filetypes = {'dockerfile'},
    root_dir = util.root_pattern('.git', vim.fn.getcwd()),
    settings = {hadolint = {hadolintPath = vim.fn.exepath('hadolint')}},
  },
}
