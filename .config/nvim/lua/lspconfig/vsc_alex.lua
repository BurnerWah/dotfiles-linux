local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'vsc_alex'
local root_pattern = util.root_pattern('.alexrc', '.alexrc.yml', '.alexrc.yaml', '.alexrc.js',
                                       'package.json', '.alexignore')

-- Oh my god this actually works
-- although I'd recommend reducing message security on your end
--
-- By default lints on save but that doesn't really work.
--
-- Root patterns don't really matter because the VSCode extension doesn't check
-- config files or ignore files. Might be worth just making my own server for this.
configs[server_name] = {
  default_config = {
    cmd = {'node', vim.fn.expand('~/.local/libexec/vscode-ext/standalone/alex-server'), '--stdio'},
    filetypes = {
      'asciidoc', 'html', 'mail', 'markdown', 'nroff', 'po', 'pod', 'rst', 'tex', 'texinfo',
      'vimwiki', 'xhtml',
    },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or root_pattern(fname) or util.path.dirname(fname)
    end,
    settings = {['alex-linter'] = {strategy = 'onType', noBinary = true}},
  },
}
