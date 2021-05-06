-- This warranted having a standalone file
local M = {}
local util = require('lspconfig/util')
local Map = require('pl.Map')

local fmt = {
  basic = function(file)
    return {(file and [[^.+?:(\d+): (.*)$]] or [[^(\d+): (.*)$]]), {line = 1, message = 2}}
  end,
  unix = function(file)
    return {
      ([[^%s(\d+):(\d+): (.*)$]]):format((file and '.+?' or '')),
      {line = 1, column = 2, message = 3},
    }
  end,
}
local security = {
  docutils = {INFO = 'info', WARNING = 'warning', ERROR = 'error', SEVERE = 'error'},
}
local tool = {
  generic = function(opts)
    local R = {}
    opts.stream = (opts.stream or 'stdout')
    -- Starting with a table can set the command and the arguments
    if type(opts[1]) == 'table' then
      opts.cmd = opts[1][1]
      table.remove(opts[1], 1)
      opts.args = opts[1]
    elseif type(opts[1]) == 'string' then
      opts.cmd = opts[1]
    end
    if opts.cmd:find('^./') then opts.name = (opts.name or opts.cmd:match('[^/]+$')) end

    R.sourceName = opts.name or opts.cmd
    R.command = opts.cmd
    R.args = opts.args or {}
    R.isStdout = opts.stream ~= 'stderr'
    R.isStderr = opts.stream ~= 'stdout'
    R.formatPattern = opts.pattern or fmt.basic()
    R.securities = opts.securities or {undefined = (opts.security or 'error')}
    if opts.roots then
      R.rootPatterns = type(opts.roots) == 'string' and {opts.roots} or opts.roots
    end
    if opts.offset then
      R.offsetLine = opts.offset.line or opts.offset[1]
      R.offsetColumn = opts.offset.column or opts.offset[2]
    end
    return R
  end,
  json = function(opts)
    local R = {}

    opts.stream = (opts.stream or 'stdout')
    -- Starting with a table can set the command and the arguments
    if type(opts[1]) == 'table' then
      opts.cmd = opts[1][1]
      table.remove(opts[1], 1)
      opts.args = opts[1]
    elseif type(opts[1]) == 'string' then
      opts.cmd = opts[1]
    end
    if opts.cmd:find('^./') then opts.name = (opts.name or opts.cmd:match('[^/]+$')) end

    R.sourceName = opts.name or opts.cmd
    R.command = opts.cmd
    R.args = opts.args or {}
    R.isStdout = opts.stream ~= 'stderr'
    R.isStderr = opts.stream ~= 'stdout'
    R.parseJson = opts.parse
    R.securities = opts.securities or {undefined = (opts.security or 'error')}
    if opts.roots then
      R.rootPatterns = type(opts.roots) == 'string' and {opts.roots} or opts.roots
    end
    if opts.offset then
      R.offsetLine = opts.offset.line or opts.offset[1]
      R.offsetColumn = opts.offset.column or opts.offset[2]
    end

    return R
  end,
  cppcheck = function(lang)
    return {
      sourceName = 'cppcheck',
      command = 'cppcheck',
      args = {
        '--quiet', ('--language=%s'):format(lang), '--enable=style', '--template',
        '{line}:{column}: {severity}:{inconclusive:inconclusive:} {message} [{id}]', '%tempfile', -- This might be bad
        -- NOTE ALE has a project folder but I think I'd need a wrapper for that
      },
      isStderr = true,
      formatPattern = {
        [[^(\d+):(\d+): (\w+): (.*)$]], {line = 1, column = 2, security = 3, message = 4},
      },
      securities = {style = 'hint', warning = 'warning', error = 'error'},
    }
  end,
}

M.linters = {
  cmakelint = tool.generic {{'cmakelint', '%file'}, pattern = fmt.basic(true), security = 'warning'},
  cppcheck_c = tool.cppcheck('c'),
  cppcheck_cpp = tool.cppcheck('c++'),
  csslint = tool.json {
    {'csslint', '--format=json', '%filepath'},
    parse = {
      errorsRoot = 'messages',
      line = 'line',
      column = 'col',
      security = 'type',
      message = '${message} (${rule.id})',
    },
    roots = '.csslintrc',
    securities = {warning = 'warning', error = 'error'},
  },
  fish = tool.generic {
    {'fish', '-n', '%file'},
    stream = 'stderr',
    pattern = {[[^.*\(line (\d+)\): (.*)$]], {line = 1, message = 2}},
  },
  flawfinder = tool.generic {
    {'flawfinder', '-CDQS', '-'},
    pattern = {
      [[^.+?:(\d+):(\d+):\s+\[(\d+)\][^:]+?:(.+)$]],
      {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {['0'] = 'hint', ['1'] = 'warning'},
  },
  gitlint = tool.generic {
    {'gitlint', '--msg-filename', '%tempfile'},
    stream = 'stderr',
    security = 'warning',
  },
  hadolint = tool.json {
    {'hadolint', '-f', 'json', '-'},
    roots = '.hadolint.yaml',
    parse = {line = 'line', column = 'column', security = 'level', message = '${message} (${code})'},
    securities = {style = 'hint', info = 'info', warning = 'warning', error = 'error'},
  },
  luacheck = tool.generic {
    {'luacheck', '--formatter=plain', '--codes', '--ranges', '%file'},
    -- Luacheck is a very loud linter, and has a tendency to get really annoying
    pattern = {
      [[^.+?:(\d+):(\d+)-(\d+): (\(([WE])\d+\) .*)$]],
      {line = 1, column = 2, endColumn = 3, security = 5, message = 4},
    },
    securities = {W = 'warning', E = 'error'},
    roots = '.luacheckrc',
  },
  markdownlint = tool.generic {
    {'markdownlint', '--stdin'},
    stream = 'both',
    pattern = {
      [[^.*?: ?(\d+)(?::(\d+))? ((?:MD\d{3}\/[\w-/]+) .*)$]], {line = 1, column = 2, message = 3},
    },
    security = 'hint',
  },
  mcs = tool.generic {
    {'mcs', '-unsafe', '--parse', '%tempfile'},
    stream = 'stderr',
    offset = {0, 1},
    pattern = {
      [[^.+?\.cs\((\d+),(\d+)\): (.+?) (.+?: .+)$]],
      {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {warning = 'warning', error = 'error'},
  },
  phpcs = {
    sourceName = 'phpcs',
    command = './vendor/bin/phpcs',
    args = {'--standard=PSR2', '--report=emacs', '-s', '-'},
    rootPatterns = {'composer.json', 'composer.lock', 'vendor', '.git'},
    formatPattern = {
      [[^.*:(\d+):(\d+):\s+(.*)\s+-\s+(.*)(\r|\n)*$]],
      {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {warning = 'warning', error = 'error'},
  },
  phpstan = {
    sourceName = 'phpstan',
    command = './vendor/bin/phpstan',
    args = {'analyze', '--error-format', 'raw', '--no-progress', '%file'},
    rootPatterns = {'composer.json', 'composer.lock', 'vendor', '.git'},
    formatPattern = {[[^[^:]+:(\d+):(.*)(\r|\n)*$]], {line = 1, message = 2}},
  },
  pylint = tool.json {
    'pylint',
    args = {
      '--jobs=0', '--output-format=json', '--score=no', '--disable=import-error',
      '--disable=wrong-import-order', '--disable=no-name-in-module', '%file',
    },
    roots = {'.git', 'pyproject.toml', 'setup.py'},
    offset = {0, 1},
    parse = {
      line = 'line',
      column = 'column',
      security = 'type',
      message = '${message} (${message-id}:${symbol})',
    },
    securities = {
      convention = 'hint',
      informational = 'hint',
      refactor = 'info',
      warning = 'warning',
      error = 'error',
      fatal = 'error',
    },
  },
  rstcheck = tool.generic {
    {'rstcheck', '-'},
    stream = 'stderr',
    pattern = {[[^.+?:(\d+): \((.+?)/\d\) (.*)$]], {line = 1, security = 2, message = 3}},
    securities = security.docutils,
  },
  rst_lint = tool.json {
    {'rst-lint', '--format=json', '%file'},
    parse = {line = 'line', security = 'type', message = '${message}'},
    securities = security.docutils,
  },
  shellcheck = tool.json {
    {'shellcheck', '--format=json', '-'},
    parse = {
      line = 'line',
      column = 'column',
      endLine = 'endLine',
      endColumn = 'endColumn',
      security = 'level',
      message = '${message} (${code})',
    },
    securities = {style = 'hint', info = 'info', warning = 'warning', error = 'error'},
  },
  sqlint = tool.generic {
    'sqlint',
    pattern = {
      [[^.+?:(\d+):(\d+):([^ ]+) (.*)$]], {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {WARNING = 'warning', ERROR = 'error'},
  },
  tidy = {
    sourceName = 'tidy',
    command = 'tidy',
    args = {'-e', '-q'},
    rootPatterns = {'.git'},
    isStderr = true,
    formatPattern = {
      [[^.*?(\d+).*?(\d+)\s+-\s+([^:]+):\s+(.*)(\r|\n)*$]],
      {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {Warning = 'warning', Error = 'error'},
  },
  tlcheck = tool.generic {
    'tlcheck',
    cmd = 'tl',
    args = {'check', '%file'},
    stream = 'both',
    pattern = fmt.unix(true),
  },
  vint = tool.json {
    {'vint', '--enable-neovim', '--json', '--style-problem', '-'},
    parse = {
      line = 'line_number',
      column = 'column_number',
      security = 'severity',
      message = '${description} (${policy_name})',
    },
    securities = {warning = 'warning', error = 'error', style_problem = 'hint'},
  },
  write_good = {
    sourceName = 'write-good',
    command = 'write-good',
    offsetColumn = 1,
    args = {'%tempfile'},
    formatPattern = {
      [[(.*) on line (\d+) at column (\d+)\s*$]], {line = 2, column = 3, message = 1},
    },
    securities = {undefined = 'hint'},
  },
  xmllint = tool.generic {
    {'xmllint', '--noout', '-'},
    stream = 'stderr',
    pattern = {[[^[^:]+:(\d+):\s*(([^:]+)\s*:.*)$]], {line = 1, security = 3, message = 2}},
    securities = {warning = 'warning'},
  },
  yamllint = tool.generic {
    {'yamllint', '-f', 'parsable', '-'},
    roots = {'.yamllint', '.yamllint.yaml', '.yamllint.yml'},
    pattern = {
      [[^.*?:(\d+):(\d+): \[(.*?)] (.*)$]], {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {warning = 'hint', error = 'error'},
    -- yamllint can only output warnings and errors, but it's mostly a style linter.
    -- so i push wanings as far down as they can go.
    -- (i feel like i have to fix linter errors & warnings, it's hard to look at files otherwise.)
  },
  zsh = tool.generic {'zsh', cmd = 'linter_run_zsh.sh', args = {'%file'}, pattern = fmt.basic(true)},
}

M.linter_filetypes = {
  asciidoc = {'write_good'},
  bats = {'shellcheck'},
  c = {'cppcheck_c', 'flawfinder'},
  cmake = {'cmakelint'},
  cpp = {'cppcheck_cpp', 'flawfinder'},
  cs = {'mcs'},
  css = {'csslint'},
  dockerfile = {'hadolint'},
  fish = {'fish'},
  gitcommit = {'gitlint'},
  html = {'tidy', 'write_good'},
  lua = {'luacheck'}, -- Luac is often redundant w/ lsp
  markdown = {'markdownlint', 'write_good'},
  nroff = {'write_good'},
  php = {'phpcs', 'phpstan'},
  po = {'write_good'},
  pod = {'write_good'},
  python = {'pylint'},
  rst = {'rstcheck', 'rst_lint', 'write_good'},
  sh = {'shellcheck'},
  sql = {'sqlint'},
  teal = {'tlcheck'},
  tex = {'write_good'},
  texinfo = {'write_good'},
  vimwiki = {'write_good'},
  xhtml = {'write_good'},
  xml = {'xmllint'},
  yaml = {'yamllint'},
  zsh = {'zsh'},
}

local roots = Map {
  lua = {'.luacheckrc'},
  dockerfile = {'.hadolint.yaml'},
  yaml = {'.yamllint', '.yamllint.yaml', '.yamllint.yaml'},
  css = {'.csslintrc'},
}
-- roots:setdefault(util.path.dirname)

function M.root_finder(fname)
  local ft = vim.bo.filetype
  local root = roots[ft]
  if root == nil then
    roots[ft] = util.path.dirname
    root = roots[ft]
  end
  if type(root) == 'table' then
    roots[ft] = util.root_pattern(unpack(root))
    root = roots[ft]
  end
  if type(root) == 'function' then return root(fname) end
end

function M.setup(self)
  local R = {}
  R.filetypes = {}
  for k, _ in pairs(self.linter_filetypes) do table.insert(R.filetypes, k) end
  R.init_options = {linters = self.linters, filetypes = self.linter_filetypes}
  R.root_dir = self.root_finder
  return R
end

return M
