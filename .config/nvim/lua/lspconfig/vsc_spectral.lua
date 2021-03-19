local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'vsc_spectral'
local root_pattern = util.root_pattern('.spectral.json', '.spectral.yaml', '.spectral.yml')

configs[server_name] = {
  default_config = {
    cmd = {
      'node',
      vim.fn.expand('~/.local/libexec/vscode-ext/stoplight.spectral/extension/server/server.js'),
      '--stdio',
    },
    filetypes = {'json', 'jsonc', 'yaml'},
    root_dir = root_pattern,
  },
}
