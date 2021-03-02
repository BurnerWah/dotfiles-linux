local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'mypyls'

configs[server_name] = {
  default_config = {
    cmd = {'mypyls'},
    filetypes = {'python'},
    root_dir = util.root_pattern('.mypy.ini', 'mypy.ini', 'pyproject.toml', '.git', vim.fn.getcwd()),
  },
}
