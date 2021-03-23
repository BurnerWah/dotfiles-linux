local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'gluonls'

-- Currently this doesn't work.
configs[server_name] = {
  default_config = {
    cmd = {'gluon_language-server'},
    filetypes = {'gluon'},
    root_dir = function(fname) return util.find_git_ancestor(fname) or util.path.dirname(fname) end,
    settings = {},
  },
}
