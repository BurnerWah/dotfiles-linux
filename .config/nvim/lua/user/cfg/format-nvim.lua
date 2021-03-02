--[[ format-nvim config
  TODO:
  - Integrate language servers
  - Integrate clang-tidy (c, cpp)
  - Limit rustfmt to one file

  Issues:
  - lua-format struggles with block comments (issues #32, #136)
--]] --
--
local cmdgen = {
  prettier = [[prettier -w --parser %s --config-precedence prefer-file --no-semi --single-quote]],
}
local function clang_tidy(file)
  local build_dir = vim.fn.findfile('compile_commands.json', vim.fn.expand(file .. ':h'))
  return ([[clang-tidy --fix --fix-errors ]] .. (build_dir ~= '' and '-p ' .. build_dir or '') ..
             file)
end

require'format'.setup {
  ['*'] = {
    {
      cmd = {
        [[sed -i 's/[ \t]*$//']], -- Remove trailing whitespace
        [[sed -i ':a; /^$/ { $d; N; ba; }']], -- Remove trailing blank lines
      },
    },
  },
  c = {{cmd = {clang_tidy}, tempfile_dir = '/tmp'}, {cmd = {'clang-format -i'}}},
  cmake = {{cmd = {'cmake-format -i'}}},
  cpp = {{cmd = {clang_tidy}, tempfile_dir = '/tmp'}, {cmd = {'clang-format -i'}}},
  css = {{cmd = {cmdgen.prettier:format 'css'}}},
  go = {{cmd = {'gofmt -w', 'goimports -w'}, tempfile_postfix = '.tmp'}},
  html = {{cmd = {cmdgen.prettier:format 'html'}}},
  javascript = {{cmd = {cmdgen.prettier:format 'javascript'}}},
  json = {{cmd = {cmdgen.prettier:format 'json'}}},
  jsonc = {{cmd = {cmdgen.prettier:format 'json'}}},
  less = {{cmd = {cmdgen.prettier:format 'less'}}},
  lua = {{cmd = {'lua-format -i'}}},
  markdown = {{cmd = {cmdgen.prettier:format 'markdown'}}},
  python = {{cmd = {'isort', 'yapf -i'}}},
  rust = {{cmd = {'rustfmt'}}}, -- NOTE This can format multiple files
  scss = {{cmd = {cmdgen.prettier:format 'scss'}}},
  sh = {{cmd = {'shfmt -i=2 -ci -w'}}},
  sql = {{cmd = {function(file) return ([[sqlformat -r %s -o %s]]):format(file, file) end}}},
  toml = {{cmd = {'taplo format'}}},
  typescript = {{cmd = {cmdgen.prettier:format 'typescript'}}},
  xml = {{cmd = {function(file) return ([[xmllint --format %s -o %s]]):format(file, file) end}}},
  yaml = {{cmd = {cmdgen.prettier:format 'yaml'}}},
}

vim.cmd [[autocmd init BufWritePost * FormatWrite]]
