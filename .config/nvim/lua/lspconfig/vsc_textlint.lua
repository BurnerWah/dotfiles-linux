local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'vsc_textlint'

configs[server_name] = {
  default_config = {
    cmd = {
      'node',
      vim.fn.expand('~/.local/libexec/vscode-ext/vscode-textlint/textlint-server/lib/server.js'),
      '--stdio',
    },
    filetypes = {
      'asciidoc', 'html', 'mail', 'markdown', 'rst', 'tex', 'texinfo', 'vimwiki', 'xhtml',
    },
    root_dir = util.root_pattern('.textlintrc', '.textlintrc.json', '.textlintrc.yml',
                                 '.textlintrc.yaml', '.textlintrc.js'),
    settings = {textlint = {run = 'onType'}},
  },
}
