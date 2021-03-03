local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'vsc_stylelint'
local root_pattern = util.root_pattern('.stylelintrc', '.stylelintrc.json', '.stylelintrc.yaml',
                                       '.stylelintrc.yml', '.stylelintrc.js', 'stylelint.config.js',
                                       'stylelint.config.cjs', 'package.json')

configs[server_name] = {
  default_config = {
    cmd = {
      'node', vim.fn.expand('~/.local/libexec/vscode-ext/vscode-stylelint/server.js'), '--stdio',
    },
    filetypes = {'css', 'html', 'less', 'sass', 'scss', 'stylus', 'sugarcss'},
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or root_pattern(fname) or util.path.dirname(fname)
    end,
  },
}
