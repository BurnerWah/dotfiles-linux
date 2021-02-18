-- This warranted having a standalone file
local M = {}

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
    opts.stream = (opts.stream or 'stdout')
    -- Starting with a table can set the command and the arguments
    if type(opts[1]) == 'table' then
      opts.cmd = opts[1][1]
      table.remove(opts[1], 1)
      opts.args = opts[1]
    end
    return {
      sourceName = (opts.name or opts.cmd or opts[1]),
      command = (opts.cmd or opts[1]),
      args = (opts.args or {}),
      isStdout = (opts.stream ~= 'stderr'),
      isStderr = (opts.stream ~= 'stdout'),
      formatPattern = (opts.pattern or fmt.basic()),
      securities = (opts.securities or {undefined = (opts.security or 'error')}),
    }
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
  alex = function(flag)
    return {
      sourceName = 'alex',
      command = 'alex',
      args = (flag and {flag, '--', '%file'} or {'--', '%file'}),
      isStdout = false,
      isStderr = true,
      formatPattern = {
        [[^ *(\d+):(\d+)-(\d+):(\d+) +warning +(.+?)  +(.+?)  +(.+)$]],
        {line = 1, column = 2, endLine = 3, endColumn = 4, message = 5},
      },
      securities = {undefined = 'warning'},
    }
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
  alex = tool.alex(),
  alex_text = tool.alex '--text',
  alex_html = tool.alex '--html',
  bashate = tool.generic {
    {'bashate', '-i', 'E003', '%tempfile'},
    pattern = {[[^.+?:(\d+):(\d+): ((E\d+) (.*))$]], {line = 1, column = 2, message = 3}},
    security = 'hint',
  },
  cmakelint = tool.generic {{'cmakelint', '%file'}, pattern = fmt.basic(true), security = 'warning'},
  cppcheck_c = tool.cppcheck 'c',
  cppcheck_cpp = tool.cppcheck 'c++',
  csslint = tool.json {
    {'csslint', '--format=json', '%filepath'},
    parse = {
      errorsRoot = 'messages',
      line = 'line',
      column = 'col',
      security = 'type',
      message = '${message} (${rule.id})',
    },
    securities = {warning = 'warning', error = 'error'},
  },
  eslint = tool.json {
    './node_modules/.bin/eslint',
    args = {'--stdin', '--stdin-filename', '%filepath', '--format', 'json'},
    roots = '.git',
    parse = {
      errorsRoot = '[0].messages',
      line = 'line',
      column = 'column',
      endLine = 'endLine',
      endColumn = 'endColumn',
      security = 'severity',
      message = '${message} (${ruleId})',
    },
    securities = {['1'] = 'warning', ['2'] = 'error'},
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
  jshint = tool.generic {
    {'jshint', '--reporter=unix', '--extract=auto', '--filename', '%filepath', '-'},
    pattern = fmt.unix(true),
    security = 'hint',
  },
  jsonlint = tool.generic {
    {'jsonlint', '--compact', '-'},
    stream = 'stderr',
    pattern = {[[^line (\d+), col (\d+), (.*)$]], {line = 1, column = 2, message = 3}},
  },
  jq = tool.generic {
    {'jq', '.', '%file'},
    stream = 'stderr',
    pattern = {
      [[^parse error: (.+) at line (\d+), column (\d+)$]], {line = 2, column = 3, message = 1},
    },
  },
  languagetool = {
    sourceName = 'languagetool',
    command = 'languagetool',
    args = {'-'},
    formatLines = 2,
    formatPattern = {
      [[^\d+?\.\)\s+Line\s+(\d+),\s+column\s+(\d+),\s+([^\n]+)\nMessage:\s+(.*)(\r|\n)*$]],
      {line = 1, column = 2, message = {4, 3}},
    },
    securities = {undefined = 'hint'},
  },
  luacheck = tool.generic {
    {'luacheck', '--formatter=plain', '--codes', '--ranges', '-', '-g'},
    pattern = {
      [[^.+?:(\d+):(\d+)-(\d+): (\(([WE])\d+\) .*)$]],
      {line = 1, column = 2, endColumn = 3, security = 5, message = 4},
    },
    securities = {W = 'warning', E = 'error'},
  },
  luac = tool.generic {{'luac', '-p', '-'}, stream = 'stderr', pattern = fmt.basic(true)},
  markdownlint = tool.generic {
    {'markdownlint', '--stdin'},
    stream = 'both',
    pattern = {
      [[^.*?: ?(\d+)(?::(\d+))? ((?:MD\d{3}\/[\w-/]+) .*)$]], {line = 1, column = 2, message = 3},
    },
    security = 'hint',
  },
  mix_credo = {
    sourceName = 'mix_credo',
    command = 'mix',
    args = {'credo', 'suggest', '--format', 'flycheck', '--read-from-stdin'},
    formatPattern = {
      [[^[^ ]+?:(\d+)(:(\d+))?:\s+([^ ]+):\s+(.*)(\r|\n)*$]],
      {line = 1, column = 3, security = 4, message = 5},
    },
    securities = {F = 'warning', C = 'warning', D = 'info', R = 'info'},
  },
  mypy = tool.generic {
    'mypy',
    args = {
      '--no-color-output', '--no-error-summary', '--show-column-numbers', '--follow-imports=silent',
      '--ignore-missing-imports', '%file',
    },
    pattern = {
      [[^.*:(\d+?):(\d+?): ([a-z]+?): (.*)$]], {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {note = 'hint', error = 'error'},
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
  proselint = tool.json {
    {'proselint', '--json'},
    parse = {
      errorsRoot = 'data.errors',
      line = 'line',
      column = 'column',
      security = 'severity',
      message = '${message} (${check})',
    },
    securities = {warning = 'hint'},
  },
  pylint = tool.json {
    'pylint',
    args = {
      '--output-format=json', '--score=no', '--disable=import-error',
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
  spectral = tool.json {
    {'spectral', 'lint', '--ignore-unknown-format', '-q', '-f', 'json'},
    parse = {
      line = 'range.start.line',
      column = 'range.start.character',
      endLine = 'range.end.line',
      endColumn = 'range.end.character',
      security = 'severity',
      message = '${message} (${code})',
    },
    securities = {['1'] = 'warning', ['2'] = 'error'},
  },
  sqlint = tool.generic {
    'sqlint',
    pattern = {
      [[^.+?:(\d+):(\d+):([^ ]+) (.*)$]], {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {WARNING = 'warning', ERROR = 'error'},
  },
  standard = {
    sourceName = 'standard',
    command = './node_modules/.bin/standard',
    args = {'--stdin', '--verbose'},
    rootPatterns = {'.git'},
    formatPattern = {
      [[^\s*<\w+>:(\d+):(\d+):\s+(.*)(\r|\n)*$]], {line = 1, column = 2, message = 3},
    },
  },
  stylelint = tool.json {
    './node_modules/.bin/stylelint',
    args = {'--formatter', 'json', '--stdin-filename', '%filepath'},
    roots = '.git',
    parse = {
      errorsRoot = '[0].warnings',
      line = 'line',
      column = 'column',
      security = 'severity',
      message = '${text}',
    },
    securities = {warning = 'warning', error = 'error'},
  },
  tidy = {
    sourceName = 'tidy',
    command = 'tidy',
    args = {'-e', '-q'},
    rootPatterns = {'.git'},
    isStderr = true,
    formatPattern = {
      [[^.*?(\d+).*?(\d+)\s+-\s+([^:]+):\s+(.*)(\r|\n)*$]],
      -- { line = 1, column = 2, endLine = 1, endColumn = 2, security = 3, message = 4 }
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
  xo = tool.json {
    {'xo', '--reporter', 'json', '--stdin', '--stdin-filename', '%filepath'},
    roots = {'package.json', '.git'},
    parse = {
      errorsRoot = '[0].messages',
      line = 'line',
      column = 'column',
      endLine = 'endLine',
      endColumn = 'endColumn',
      security = 'severity',
      message = '${message} (${ruleId})',
    },
    securities = {['1'] = 'warning', ['2'] = 'error'},
  },
  yamllint = tool.generic {
    {'yamllint', '-f', 'parsable', '-'},
    pattern = {
      [[^.*?:(\d+):(\d+): \[(.*?)] (.*)$]], {line = 1, column = 2, security = 3, message = 4},
    },
    securities = {warning = 'warning', error = 'error'},
  },
  zsh = tool.generic {'zsh', cmd = 'linter_run_zsh.sh', args = {'%file'}, pattern = fmt.basic(true)},
}

M.linter_filetypes = {
  asciidoc = {'alex_text', 'languagetool', 'proselint', 'write_good'},
  bats = {'shellcheck'},
  c = {'cppcheck_c', 'flawfinder'},
  cmake = {'cmakelint'},
  cpp = {'cppcheck_cpp', 'flawfinder'},
  css = {'csslint', 'stylelint'},
  dockerfile = {'hadolint'},
  elixir = {'mix_credo'},
  fish = {'fish'},
  fountain = {'proselint'},
  gitcommit = {'gitlint'},
  graphql = {'eslint'},
  html = {'alex_html', 'proselint', 'tidy', 'write_good'},
  javascript = {'eslint', 'jshint', 'standard', 'xo'},
  json = {'jsonlint', 'jq', 'spectral'},
  jsonc = {'spectral'}, -- NOTE could add more to this with strip-json-comments
  less = {'stylelint'},
  lua = {'luac', 'luacheck'},
  mail = {'alex_text', 'languagetool', 'proselint'},
  markdown = {'alex', 'languagetool', 'markdownlint', 'proselint', 'write_good'},
  nroff = {'alex_text', 'proselint', 'write_good'},
  php = {'phpcs', 'phpstan'},
  po = {'alex', 'proselint', 'write_good'},
  pod = {'alex', 'proselint', 'write_good'},
  python = {'mypy', 'pylint'},
  rst = {'alex_text', 'proselint', 'rstcheck', 'rst_lint', 'write_good'},
  sass = {'stylelint'},
  scss = {'stylelint'},
  stylus = {'stylelint'},
  sugarcss = {'stylelint'},
  sh = {'bashate', 'shellcheck'},
  sql = {'sqlint'},
  teal = {'tlcheck'},
  tex = {'alex_text', 'proselint', 'write_good'},
  texinfo = {'alex_text', 'proselint', 'write_good'},
  typescript = {'eslint', 'standard', 'xo'},
  vimwiki = {'alex_text', 'languagetool', 'proselint', 'write_good'},
  vue = {'eslint'},
  xhtml = {'alex_text', 'proselint', 'write_good'},
  xml = {'xmllint'},
  yaml = {'spectral', 'yamllint'},
  zsh = {'zsh'},
}

function M.setup(self)
  local R = {}
  R.filetypes = {}
  for k, _ in pairs(self.linter_filetypes) do table.insert(R.filetypes, k) end
  R.init_options = {linters = self.linters, filetypes = self.linter_filetypes}
  return R
end

return M
