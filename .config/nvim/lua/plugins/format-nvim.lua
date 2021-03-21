-- format-nvim config
-- TODO:
-- - Integrate language servers
-- - Integrate clang-tidy (c, cpp)
-- - Limit rustfmt to one file
--
-- Issues:
-- - lua-format struggles with block comments (issues #32, #136)
assert(true)

---Collection of shared tools & tool generators to ensure consistent configurations
local tool = {
  ---Simple generator for a tool
  ---@param cmd string|function
  ---@param region? table
  ---@param opts? table
  ---@return table
  generate = function(cmd, region, opts)
    local R = {cmd = {cmd}}
    if region then
      R.start_pattern, R.end_pattern = unpack(region[1])
      if region[2] then R.target = region[2] end
    end
    if opts then vim.tbl_extend('force', R, opts) end
    return R
  end,

  ---clang-format
  clang_format = {cmd = {'clang-format -i'}},

  ---clang-tidy
  clang_tidy = {
    cmd = {
      function(file)
        local build_dir = vim.fn.findfile('compile_commands.json', vim.fn.expand(file .. ':h'))
        build_dir = (build_dir ~= '' and '-p ' .. build_dir or build_dir)
        return string.format('clang-tidy --fix --fix-errors %s %s', build_dir, file)
      end,
    },
    tempfile_dir = '/tmp',
  },

  ---Generate a prettier tool for a parser
  ---@param parser string The parser to use
  ---@return table
  prettier = function(parser)
    return {
      cmd = {
        List {
          'prettier', '-w', '--parser', parser, '--config-precedence', 'prefer-file', '--no-semi',
          '--single-quote',
        }:concat(' '),
      },
    }
  end,

  ---sqlformat
  sqlformat = {cmd = {function(F) return string.format('sqlformat -r %s -o %s', F, F) end}},

  ---xmllint
  xmllint = {cmd = {function(F) return string.format('xmllint --format %s -o %s', F, F) end}},
}

require('format').setup {
  ['*'] = {
    {cmd = {[[sed -i 's/[ \t]*$//']], [[sed -i ':a; /^$/ { $d; N; ba; }']]}},
    -- Remove trailing whitespace & trailing blank lines
  },

  c = {tool.clang_tidy, tool.clang_format},

  cmake = {{cmd = {'cmake-format -i'}}},

  cpp = {tool.clang_tidy, tool.clang_format},

  css = {tool.prettier('css')},

  go = {{cmd = {'gofmt -w', 'goimports -w'}, tempfile_postfix = '.tmp'}},

  html = {tool.prettier('html')},

  javascript = {tool.prettier('javascript')},

  json = {tool.prettier('json')},

  jsonc = {tool.prettier('json')},

  less = {tool.prettier('less')},

  lua = {{cmd = {'lua-format -i'}}},

  markdown = {
    tool.prettier('markdown'), tool.generate('lua-format -i', {{'^```lua$', '^```$'}, 'current'}),
  },

  python = {{cmd = {'isort', 'black'}}},

  rust = {{cmd = {'rustfmt'}}}, -- NOTE This can format multiple files

  scss = {tool.prettier('scss')},

  sh = {{cmd = {'shfmt -i=2 -ci -w'}}},

  sql = {tool.sqlformat},

  toml = {{cmd = {'taplo format'}}},

  typescript = {tool.prettier('typescript')},

  vim = {{cmd = {'lua-format -i'}, start_pattern = '^lua << EOF$', end_pattern = '^EOF$'}},

  vimwiki = {
    {cmd = 'lua-format -i', start_pattern = '^{{{lua$', end_pattern = '^}}}$', target = 'current'},
  },

  xml = {tool.xmllint},

  yaml = {tool.prettier('yaml')},
}

vim.cmd [[autocmd init BufWritePost * FormatWrite]]
