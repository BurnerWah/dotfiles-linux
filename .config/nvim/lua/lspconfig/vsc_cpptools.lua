local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'vsc_cpptools'

-- Oh my god this actually works
-- although I'd recommend reducing message security on your end
configs[server_name] = {
  default_config = {
    cmd = {vim.fn.expand('~/.local/libexec/vscode-ext/ms-vscode.cpptools-1.2.2/bin/cpptools')},
    filetypes = {'c', 'cpp'},
    root_dir = util.root_pattern('.git', vim.fn.getcwd()),
  },
}
