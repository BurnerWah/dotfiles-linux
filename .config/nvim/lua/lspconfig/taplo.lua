local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'taplo'
local bin_name = 'taplo-lsp'

configs[server_name] = {
  default_config = {
    cmd = {bin_name, 'run'},
    filetypes = {'toml'},
    root_dir = util.root_pattern('.git', vim.fn.getcwd()),
  },
}
