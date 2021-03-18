local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'eslint_lsp'
local bin_name = 'eslint-lsp'
local root_pattern = util.root_pattern('.eslintrc', '.eslintrc.js', '.eslintrc.cjs',
                                       '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json',
                                       'package.json')

configs[server_name] = {
  default_config = {
    cmd = {bin_name, '--stdio'},
    filetypes = {'graphql', 'javascript', 'typescript', 'vue'},
    root_dir = function(fname) return util.find_git_ancestor(fname) or root_pattern(fname) end,
    -- root_dir = util.root_pattern('.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml',
    --                              '.eslintrc.yml', '.eslintrc.json', 'package.json'),
  },
}
