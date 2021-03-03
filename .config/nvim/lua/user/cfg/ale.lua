-- Standalone ALE config
vim.g.ale_fix_on_save = false
vim.g.ale_disable_lsp = true
vim.g.ale_linters_ignore = {
  --[[
    I'm using this to disable linters that should not be handled by ALE.
    That includes stuff handled by another plugin, and stuff that isn't helpful.

    potential things to convert:
    - gawk [ awk ] (packaged)
    - clazy [ cpp ] (packaged)
    - msgfmt [ po ] (packaged)
    - redpen [ asciidoc, markdown, review, rst, tex, text ]
    - textlint [ asciidoc, markdown, rst, tex, text ]
    - chktex [ tex ] (packaged)
    - lacheck [ tex ] (packaged)

    require conversion before use:
    - eslint (with eslint_d or vscode extension)
    - textlint (via vscode extension)
    - redpen (via vscode extension)
    - standard (via vscode extension)
    - htmlhint (via vscode extension)
    - spectral (via vscode extension)
    - tslint (maybe via vscode extension)
    - languagetool (need to figure out how to load the lsp)

    server needs more work:
    - xo (connects via IPC)
    - jshint (connects via IPC)

    handled by servers:
    - mypy
    - alex (vscode extension)
    - stylelint (vscode extension)

    intentionally unhandled:
    - vale (dumb)
    - proselint (very dumb)
    - typecheck (not maintained)
    - fecs (not in english so probably unussable for me)
    - jscs (merged with eslint)
    - sasslint (not maintained)
  ]]
  asciidoc = {'alex', 'languagetool', 'proselint', 'redpen', 'textlint', 'vale', 'writegood'},
  bats = {'shellcheck'},
  c = {'cc', 'clangtidy', 'cppcheck', 'cpplint', 'flawfinder'},
  cmake = {'cmakelint'},
  cpp = {'cc', 'clangcheck', 'clangtidy', 'cppcheck', 'cpplint', 'flawfinder'},
  cs = {'mcs'},
  css = {'csslint', 'fecs', 'stylelint'},
  dockerfile = {'hadolint'},
  elixir = {'credo'},
  eruby = {'erb'},
  fish = {'fish'},
  fountain = {'proselint'},
  gitcommit = {'gitlint'},
  graphql = {'eslint'},
  help = {'alex', 'proselint', 'writegood'},
  html = {'alex', 'fecs', 'htmlhint', 'proselint', 'stylelint', 'tidy', 'writegood'},
  javascript = {'eslint', 'fecs', 'flow', 'jscs', 'jshint', 'standard', 'xo'},
  json = {'jsonlint', 'jq', 'spectral'},
  less = {'stylelint'},
  lua = {'luacheck', 'luac'},
  mail = {'alex', 'languagetool', 'proselint', 'vale'},
  markdown = {
    'alex', 'languagetool', 'markdownlint', 'mdl', 'proselint', 'redpen', 'textlint', 'vale',
    'writegood',
  },
  nroff = {'alex', 'proselint', 'writegood'},
  objc = {'clang'},
  objcpp = {'clang'},
  php = {'phpcs', 'phpstan'},
  po = {'alex', 'proselint', 'writegood'},
  pod = {'alex', 'proselint', 'writegood'},
  python = {'flake8', 'mypy', 'pylint'},
  rst = {'alex', 'proselint', 'redpen', 'rstcheck', 'textlint', 'vale', 'writegood'},
  rust = {'cargo'},
  sass = {'sasslint', 'stylelint'},
  scss = {'sasslint', 'stylelint'},
  sh = {'bashate', 'shellcheck'},
  sql = {'sqlint'},
  stylus = {'stylelint'},
  sugarss = {'stylelint'},
  teal = {'tlcheck'},
  tex = {'alex', 'proselint', 'redpen', 'textlint', 'vale', 'writegood'},
  texinfo = {'alex', 'proselint', 'writegood'},
  typescript = {'eslint', 'standard', 'tslint', 'typecheck', 'xo'},
  vim = {'vint'},
  vimwiki = {'alex', 'languagetool', 'proselint', 'markdownlint', 'mdl', 'remark-lint', 'writegood'},
  vue = {'eslint'},
  xhtml = {'alex', 'proselint', 'writegood'},
  xsd = {'xmllint'},
  xml = {'xmllint'},
  xslt = {'xmllint'},
  yaml = {'spectral', 'yamllint'},
  zsh = {'shell'},
}
require('user.cleanup.ale')
