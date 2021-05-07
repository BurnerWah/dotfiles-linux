-- Standalone ALE config
vim.g.ale_fix_on_save = false
vim.g.ale_disable_lsp = true
vim.g.ale_linters_ignore = {
  ada = {'gcc'},
  asciidoc = {'alex', 'languagetool', 'proselint', 'redpen', 'textlint', 'vale', 'writegood'},
  asm = {'gcc'},
  bats = {'shellcheck'},
  c = {'cc', 'clangtidy', 'cppcheck', 'cpplint', 'flawfinder', 'gcc'},
  cmake = {'cmakelint'},
  cpp = {'cc', 'clangcheck', 'clangtidy', 'cppcheck', 'cpplint', 'flawfinder', 'gcc'},
  cs = {'mcs'},
  css = {'csslint', 'fecs', 'stylelint'},
  dockerfile = {'hadolint'},
  elixir = {'credo'},
  eruby = {'erb'},
  fish = {'fish'},
  fortran = {'gcc'},
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
  python = {'flake8', 'mypy', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylint'},
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

-- Async cleanup
local cleanup
cleanup = vim.loop.new_async(vim.schedule_wrap(function()
  -- Script to clean up dead ALE commands & maps (namely LSP stuff)
  local unmap = {
    'ale_documentation', 'ale_find_references', 'ale_go_to_definition',
    'ale_go_to_definition_in_tab', 'ale_go_to_definition_in_split',
    'ale_go_to_definition_in_vsplit', 'ale_go_to_type_definition',
    'ale_go_to_type_definition_in_tab', 'ale_go_to_type_definition_in_split',
    'ale_go_to_type_definition_in_vsplit', 'ale_hover', 'ale_import', 'ale_rename',
    'ale_code_action',
  }
  for _, map in ipairs(unmap) do vim.cmd('unmap <Plug>(' .. map .. ')') end
  vim.cmd [[iunmap <Plug>(ale_complete)]]

  local delcom = {
    'ALEComplete', 'ALEDocumentation', 'ALEFindReferences', 'ALEGoToDefinition',
    'ALEGoToTypeDefinition', 'ALEHover', 'ALEImport', 'ALEOrganizeImports', 'ALERename',
    'ALECodeAction', 'ALESymbolSearch', 'ALEStopAllLSPs',
  }
  for _, cmd in ipairs(delcom) do vim.cmd('delcommand ' .. cmd) end

  cleanup:close()
end))

cleanup:send()
