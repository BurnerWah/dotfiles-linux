-- Filetype notes
-- Known issues:
-- - JSON With comments isn't detected (this is a general issue right now)
-- - Shebang detection isn't great (plenary issue)
--     In more detail, it only does exact matches, so it misses anything with arguments
-- Other notes:
-- - Zsh is present in here a lot to override base settings
local shebang_prefixes = {'/usr/bin/', '/bin/', '/usr/bin/env ', '/bin/env '}
local shebang_fts = {
  ['awk -f'] = 'awk', -- Needed for plenary to work
  ['fennel'] = 'fennel',
  ['fish'] = 'fish',
  ['gawk -f'] = 'awk', -- Needed for plenary to work
  ['gjs'] = 'javascript', -- GJS Scripts
  ['gjs-console'] = 'javascript', -- GJS Scripts
  ['lua'] = 'lua',
  ['moon'] = 'moon',
  ['node'] = 'javascript',
  ['ruby'] = 'ruby',
  ['tl'] = 'teal',
}
local shebang = {}
for _, prefix in ipairs(shebang_prefixes) do
  for k, v in pairs(shebang_fts) do shebang[prefix .. k] = v end
end
local special = {asa = (vim.g.filetype_asa or 'aspvbs')}

return {
  extension = {
    ['aiml'] = 'xml', -- Artificial Intelligence Markup Language
    ['asa'] = special.asa,
    ['cjsn'] = 'jsonc',
    ['cjson'] = 'jsonc',
    ['comp'] = 'glsl', -- From vim-glsl
    ['doap'] = 'xml', -- Description of a project
    ['fish'] = 'fish',
    ['frag'] = 'glsl', -- From vim-glsl
    ['geom'] = 'glsl', -- From vim-glsl
    ['glsl'] = 'glsl', -- From vim-glsl
    ['gql'] = 'graphql',
    ['graphql'] = 'graphql',
    ['graphqls'] = 'graphql',
    ['info'] = 'info',
    ['iuml'] = 'plantuml',
    ['jsonc'] = 'jsonc',
    ['jsonld'] = 'json', -- JSON Linked Data
    ['ll'] = 'llvm',
    ['lzx'] = 'xml', -- OpenLaszlo
    ['mlir'] = 'mlir', -- from LLVM
    ['moon'] = 'moon',
    ['org'] = 'org', -- vim-orgmode
    ['pip'] = 'requirements',
    ['plantuml'] = 'plantuml',
    ['posxml'] = 'xml', -- Posxml
    ['pu'] = 'plantuml',
    ['puml'] = 'plantuml',
    ['resjson'] = 'json', -- Windows App localization
    ['ron'] = 'ron',
    ['snippets'] = 'snippets',
    ['spec'] = 'spec', -- RPM Spec
    ['td'] = 'tablegen',
    ['tesc'] = 'glsl', -- From vim-glsl
    ['tese'] = 'glsl', -- From vim-glsl
    ['tl'] = 'teal',
    ['tmLanguage'] = 'xml', -- Textmate language
    ['toml'] = 'toml',
    ['ublock.txt'] = 'ublock', -- Custom filetype
    ['uml'] = 'plantuml',
    ['vert'] = 'glsl', -- From vim-glsl
    ['wrap'] = 'dosini', -- From meson.vim
    ['xlisp'] = 'lisp',
    ['zsh'] = 'zsh',
  },
  file_name = {
    ['.arclint'] = 'json',
    ['.avcs'] = 'json', -- Avro Schema
    ['.babelrc'] = 'jsonc', -- Babel config (alias to .babelrc.json)
    ['.babelrc.json'] = 'jsonc', -- Babel config
    ['.bootstraprc'] = 'yaml',
    ['.bowerrc'] = 'json', -- Bower config
    ['.coveragerc'] = 'dosini',
    ['.csslintrc'] = 'json', -- CSS Lint config
    ['.eslintrc'] = 'jsonc', -- ESLint config
    ['.jsbeautifyrc'] = 'jsonc', -- js-beautify config; could have comments
    ['.jscsrc'] = 'json', -- JSCS config
    ['.jshintrc'] = 'jsonc', -- JSHint config
    ['.jsinspectrc'] = 'json', -- JSInspect config
    ['.jslintrc'] = 'jsonc',
    ['.luacompleterc'] = 'json',
    ['.manpath'] = 'manconf', -- User manpath
    ['.mocharc.json'] = 'jsonc', -- MochaJS config
    ['.mocharc.jsonc'] = 'jsonc', -- MochaJS config
    ['.modernizrrc'] = 'json', -- Webpack modernizr-loader config
    ['.npmpackagejsonlintrc'] = 'json', -- npm-package-json-lint config
    ['.proselintrc'] = 'json',
    ['.tcelldb'] = 'json',
    ['.viminfo'] = 'viminfo',
    ['.wgetrc'] = 'wget',
    ['.zlogin'] = 'zsh',
    ['.zlogout'] = 'zsh',
    ['.zprofile'] = 'zsh',
    ['.zsh_history'] = 'zshhist', -- Custom filetype
    ['.zshenv'] = 'zsh',
    ['.zshrc'] = 'zsh',
    ['_exrc'] = 'vim',
    ['_viminfo'] = 'viminfo',
    ['anacrontab'] = 'crontab',
    ['babelrc.config.json'] = 'jsonc', -- Babel config
    ['cargo.lock'] = 'toml',
    ['coc-settings.json'] = 'jsonc', -- Coc.nvim config
    ['coffeelint.json'] = 'jsonc', -- Coffeelint config
    ['constraints.in'] = 'requirements',
    ['constraints.txt'] = 'requirements',
    ['fish_history'] = 'yaml',
    ['gdbinit'] = 'gdb',
    ['gopkg.lock'] = 'toml',
    ['index.theme'] = 'desktop', -- Icon theme index
    ['jsconfig.json'] = 'jsonc', -- JS project config
    ['man_db.conf'] = 'manconf', -- System mandb config (on Fedora)
    ['meson.build'] = 'meson',
    ['meson_options.txt'] = 'meson',
    ['mimeapps.list'] = 'desktop', -- XDG Default Applications
    ['mimeinfo.cache'] = 'desktop', -- XDG Mime cache
    ['nfs.conf'] = 'dosini',
    ['pipfile'] = 'toml',
    ['proselintrc'] = 'json',
    ['requirements.in'] = 'requirements',
    ['requirements.txt'] = 'requirements',
    ['requires.in'] = 'requirements',
    ['requires.txt'] = 'requirements',
    ['robots.txt'] = 'robots',
    ['rpkg.conf'] = 'dosini',
    ['sestatus.conf'] = 'dosini',
    ['trolltech.conf'] = 'dosini',
    ['tsconfig.json'] = 'jsonc', -- TS project config
    ['virc'] = 'vim',
    ['vkBasalt.conf'] = 'dosini',
    ['wgetrc'] = 'wget',
    ['youtube-dl.conf'] = 'argfile', -- Custom filetype
    ['zlogin'] = 'zsh',
    ['zlogout'] = 'zsh',
    ['zprofile'] = 'zsh',
    ['zshenv'] = 'zsh',
    ['zshrc'] = 'zsh',
  },
  shebang = shebang,
}
