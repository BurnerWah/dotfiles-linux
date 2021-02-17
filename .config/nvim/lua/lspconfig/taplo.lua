local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'taplo'
local bin_name = 'taplo-lsp'

configs[server_name] = {
  default_config = {
    cmd = {bin_name, 'run'},
    filetypes = {'toml'},
    root_dir = function(fname)
      local root_pattern = util.root_pattern('.taplo.toml', 'taplo.toml')
      return root_pattern(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
}
