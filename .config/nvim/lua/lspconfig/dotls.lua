local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'dotls'
local bin_name = 'dot-language-server'

configs[server_name] = {
  default_config = {
    cmd = {bin_name, '--stdio'},
    filetypes = {'dot'},
    root_dir = util.root_pattern(".git", vim.fn.getcwd())
  }
}
