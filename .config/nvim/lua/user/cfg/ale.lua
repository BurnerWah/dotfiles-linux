-- Standalone ALE config
vim.g.ale_fix_on_save = true
vim.g.ale_disable_lsp = true
vim.g.ale_linters_ignore = {
  --[[
    I'm using this to disable linters that should not be handled by ALE.
    That includes stuff handled by another plugin, and stuff that isn't helpful.

    potential things to convert:
    - fecs [ css, html, javascript ]
    - gawk [ awk ] (packaged)
    - clangcheck [ cpp ] (packaged)
    - cppcheck [ c, cpp ] (packaged)
    - clazy [ cpp ] (packaged)
    - flawfinder [ c, cpp ] (packaged)
    - vale [ asciidoc, mail, markdown, rst, tex, text ]
    - msgfmt [ po ] (packaged)
    - redpen [ asciidoc, markdown, review, rst, tex, text ]
    - textlint [ asciidoc, markdown, rst, tex, text ]
    - chktex [ tex ] (packaged)
    - lacheck [ tex ] (packaged)
  ]]
  asciidoc = { 'alex', 'languagetool', 'proselint', 'writegood' }, -- enabled: redpen, textlint, vale
  bats = { 'shellcheck' }, -- DISABLED
  c = { 'cc', 'clangtidy', 'cpplint' }, -- enabled: cppcheck, flawfinder
  cmake = { 'cmakelint' }, -- DISABLED
  cpp = { 'cc', 'clangtidy', 'cpplint' }, -- enabled: clangcheck, clazy, cppcheck, flawfinder
  css = { 'csslint', 'stylelint' }, -- enabled: fecs
  dockerfile = { 'hadolint' }, -- enabled: dockerfile_lint
  elixir = { 'credo' },
  eruby = { 'erb' },
  fish = { 'fish' }, -- DISABLED
  fountain = { 'proselint' }, -- DISABLED
  gitcommit = { 'gitlint' }, -- DISABLED
  graphql = { 'eslint' }, -- enabled: gqlint
  help = { 'alex', 'proselint', 'writegood' }, -- DISABLED
  html = { 'alex', 'proselint', 'tidy', 'writegood' }, -- enabled: fecs, htmlhint
  javascript = { 'eslint', 'jshint', 'flow', 'standard', 'xo' }, -- enabled: fecs, jscs
  json = { 'jsonlint', 'spectral' }, -- DISABLED
  -- jsonc = { 'jsonlint', 'spectral' },
  less = { 'stylelint' }, -- enabled: lessc
  lua = { 'luacheck', 'luac' }, -- DISABLED
  mail = { 'alex', 'languagetool', 'proselint' }, -- enabled: vale
  markdown = { 'alex', 'languagetool', 'markdownlint', 'proselint', 'writegood' },
  nroff = { 'alex', 'proselint', 'writegood' }, -- DISABLED
  objc = { 'clang' }, -- DISABLED
  objcpp = { 'clang' }, -- DISABLED
  php = { 'phpcs', 'phpstan' },
  po = { 'alex', 'proselint', 'writegood' }, -- enabled: msgfmt
  pod = { 'alex', 'proselint', 'writegood' }, -- DISABLED
  python = { 'flake8', 'mypy', 'pylint' },
  rst = { 'alex', 'proselint', 'rstcheck', 'writegood' }, -- enabled: redpen, textlint, vale
  rust = { 'cargo' }, -- DISABLED
  sass = { 'stylelint' }, -- enabled: sasslint
  scss = { 'stylelint' }, -- enabled: sasslint, scss-lint
  sh = { 'bashate', 'shellcheck' }, -- enabled: shell
  sql = { 'sqlint' }, -- enabled: sqllint
  stylus = { 'stylelint' }, -- DISABLED
  sugarss = { 'stylelint' }, -- DISABLED
  teal = { 'tlcheck' }, -- DISABLED
  tex = { 'alex', 'proselint', 'writegood' }, -- enabled: chktex, lacheck, redpen, textlint, vale
  texinfo = { 'alex', 'proselint', 'writegood' }, -- DISABLED
  typescript = { 'eslint', 'standard', 'tslint', 'xo' }, -- enabled: typecheck
  vim = { 'vint' }, -- enabled: ale_custom_linting_rules
  vimwiki = { 'alex', 'languagetool', 'proselint', 'markdownlint', 'mdl', 'remark-lint', 'writegood' },
  vue = { 'eslint' },
  xhtml = { 'alex', 'proselint', 'writegood' }, -- DISABLED
  xsd = { 'xmllint' }, -- DISABLED
  xml = { 'xmllint' }, -- DISABLED
  xslt = { 'xmllint' }, -- DISABLED
  yaml = { 'spectral', 'yamllint' }, -- enabled: swaglint
  zsh = { 'shell' },
}
vim.g.ale_fixers = {
  ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
  cpp = { 'clangtidy', 'remove_trailing_lines', 'trim_whitespace' },
  go = { 'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace' },
  html = { 'tidy', 'remove_trailing_lines', 'trim_whitespace' },
  markdown = {},
  python = {
    'add_blank_lines_for_python_control_statements',
    'reorder-python-imports',
    'remove_trailing_lines',
    'trim_whitespace',
  },
  rust = { 'rustfmt', 'remove_trailing_lines', 'trim_whitespace' },
  sql = { 'sqlformat', 'remove_trailing_lines', 'trim_whitespace' },
  xml = { 'xmllint' },
}
vim.cmd [[autocmd init VimEnter * lua require('user.cleanup.ale')]]
