local lspconfig = require'lspconfig'
--[[ TODO add on_attach function
  This is mostly held up by neovim pull #13823 (https://github.com/neovim/neovim/pull/13823),
  which adds a better way to manage keymaps. Once that's merged, stuff can be moved into here.
  ]]

lspconfig.bashls.setup {}
lspconfig.ccls.setup {
  init_options = {
    compilationDatabaseDirectory = 'build',
    index = { threads = 0 },
    cache = { directory = '.ccls-cache' },
    clang = { resourceDir = '/usr/lib64/clang/11' },
    highlight = { lsRanges = true },
  },
}
lspconfig.cmake.setup {}
lspconfig.cssls.setup {}
lspconfig.dotls.setup {}
lspconfig.dockerls.setup {}
lspconfig.fortls.setup {}
lspconfig.gopls.setup {
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
}
lspconfig.html.setup {}
lspconfig.jedi_language_server.setup {}
lspconfig.jsonls.setup {}
lspconfig.pyls.setup {
  settings = {
    pyls = {
      configurationSources = {'pyflakes', 'pycodestyle'},
      plugins = {
        jedi_completion = {enabled = true},
        jedi_hover = {enabled = true},
        jedi_references = {enabled = true},
        jedi_signature_help = {enabled = true},
        jedi_symbols = {enabled = true, all_scopes = true},
        mccabe = {enabled = true, threshold = 15},
        preload = {enabled = true},
        pycodestyle = {enabled = true},
        pydocstyle = {enabled = false},
        pyflakes = {enabled = false},
        rope_completion = {enabled = true},
        yapf = {enabled = true}
      }
    }
  }
}
lspconfig.pyright.setup {}
lspconfig.rls.setup {
  settings = {
    rust = {
      clippy_preference = 'on',
    },
  },
}
lspconfig.sqls.setup {}
lspconfig.sqlls.setup {
  cmd = {'sql-language-server', 'up', '--method', 'stdio'},
}
lspconfig.sumneko_lua.setup {
  cmd = {'lua-language-server'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim', 'use', 'packer_plugins'},
        disable = {'lowercase-global'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.stdpath('data')..'/site/lua_types'] = true,
        },
      },
    },
  },
}
lspconfig.taplo.setup {}
lspconfig.tsserver.setup {}
lspconfig.vimls.setup {}
lspconfig.yamlls.setup {}

-- The giant language servers - diagnosticls & efm
-- more linters are @ https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
lspconfig.efm.setup {
  filetypes = { 'eruby', 'make', 'zsh' },
}
lspconfig.diagnosticls.setup {
  filetypes = {
    'asciidoc',
    'bats',
    'cmake',
    'css',
    'dockerfile',
    'elixir',
    'fountain',
    'fish',
    'gitcommit',
    'graphql',
    'html',
    'javascript',
    'json',
    'less',
    'lua',
    'mail',
    'markdown',
    'nroff',
    'php',
    'po',
    'pod',
    'python',
    'rst',
    'sass',
    'scss',
    'stylus',
    'sugarcss',
    'sh',
    'sql',
    'teal',
    'tex',
    'texinfo',
    'typescript',
    'vimwiki',
    'vue',
    'xhtml',
    'xml',
    'yaml',
    'zsh',
  },
  init_options = {
    linters = {
      alex = {
        sourceName = 'alex',
        command = 'alex',
        args = { '--', '%file' },
        isStdout = false,
        isStderr = true,
        formatPattern = {
          [[^ *(\d+):(\d+)-(\d+):(\d+) +warning +(.+?)  +(.+?)  +(.+)$]],
          { line = 1, column = 2, endLine = 3, endColumn = 4, message = 5 }
        },
        securities = { undefined = 'warning' },
      },
      alex_text = {
        sourceName = 'alex',
        command = 'alex',
        args = { '--text', '--', '%file' },
        isStdout = false,
        isStderr = true,
        formatPattern = {
          [[^ *(\d+):(\d+)-(\d+):(\d+) +warning +(.+?)  +(.+?)  +(.+)$]],
          { line = 1, column = 2, endLine = 3, endColumn = 4, message = 5 }
        },
        securities = { undefined = 'warning' },
      },
      alex_html = {
        sourceName = 'alex',
        command = 'alex',
        args = { '--html', '--', '%file' },
        isStdout = false,
        isStderr = true,
        formatPattern = {
          [[^ *(\d+):(\d+)-(\d+):(\d+) +warning +(.+?)  +(.+?)  +(.+)$]],
          { line = 1, column = 2, endLine = 3, endColumn = 4, message = 5 }
        },
        securities = { undefined = 'warning' },
      },
      bashate = {
        sourceName = 'bashate',
        command = 'bashate',
        args = {'-i', 'E003', '%tempfile'},
        formatPattern = { [[^[^:]+:(\d+):(\d+): ((E\d+) (.*))$]], { line = 1, column = 2, message = 3 } },
        securities = { undefined = 'hint' },
      },
      cmakelint = {
        sourceName = 'cmakelint',
        command = 'cmakelint',
        args = {'%file'},
        offsetColumn = -1,
        formatPattern = { [[^.+?:(\d+): (.*)$]], { line = 1, message = 2 } },
        securities = { undefined = 'warning' },
      },
      csslint = {
        sourceName = 'csslint',
        command = 'csslint',
        args = { '--format=json', '%filepath' },
        parseJson = {
          errorsRoot = 'messages',
          line = 'line',
          column = 'col',
          security = 'type',
          message = '${message} (${rule.id})',
        },
        securities = { warning = 'warning', error = 'error' },
      },
      eslint = {
        sourceName = 'eslint',
        command = './node_modules/.bin/eslint',
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        rootPatterns = {'.git'},
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          security = 'severity',
          message = '${message} (${ruleId})',
        },
        securities = { ['1'] = 'warning', ['2'] = 'error' },
      },
      fish = {
        sourceName = 'fish',
        command = 'fish',
        args = {'-n', '%file'},
        isStdout = false,
        isStderr = true,
        offsetColumn = -1,
        formatPattern = { [[^.*\(line (\d+)\): (.*)$]], { line = 1, message = 2 } }
      },
      gitlint = {
        sourceName = 'gitlint',
        command = 'gitlint',
        args = { '--msg-filename', '%tempfile' },
        isStdout = false,
        isStderr = true,
        offsetColumn = { [[^(\d+): (.*)$]], { line = 1, message = 2 } },
        securities = { undefined = 'warning' },
      },
      hadolint = {
        sourceName = 'hadolint',
        command = 'hadolint',
        args = {'-f', 'json', '-'},
        rootPatterns = { '.hadolint.yaml' },
        parseJson = {
          line = 'line',
          column = 'column',
          security = 'level',
          message = '${message} (${code})',
        },
        securities = { style = 'hint', info = 'info', warning = 'warning', error = 'error' },
      },
      jshint = {
        sourceName = 'jshint',
        command = 'jshint',
        args = { '--reporter=unix', '--extract=auto', '--filename', '%filepath', '-' },
        formatPattern = { [[^[^:]+:(\d+):(\d+): (.+)$]], { line = 1, column = 2, message = 3 } },
        securities = { undefined = 'hint' },
      },
      jsonlint = {
        sourceName = 'jsonlint',
        command = 'jsonlint',
        args = { '--compact', '-' },
        isStdout = false,
        isStderr = true,
        formatPattern = { [[^line (\d+), col (\d+), (.*)$]], { line = 1, column = 2, message = 3 } },
      },
      languagetool = {
        sourceName = 'languagetool',
        command = 'languagetool',
        args = {'-'},
        formatLines = 2,
        formatPattern = {
          [[^\d+?\.\)\s+Line\s+(\d+),\s+column\s+(\d+),\s+([^\n]+)\nMessage:\s+(.*)(\r|\n)*$]],
          { line = 1, column = 2, message = { 4, 3 } }
        },
      },
      luacheck = {
        sourceName = 'luacheck',
        command = 'luacheck',
        args = { '--formatter=plain', '--codes', '--ranges', '-', '-g' },
        formatPattern = {
          [[^.+?:(\d+):(\d+)-(\d+): (\(([WE])\d+\) .*)$]],
          { line = 1, column = 2, endColumn = 3, security = 5, message = 4 }
        },
        securities = { W = 'warning', E = 'error' },
      },
      luac = {
        sourceName = 'luac',
        command = 'luac',
        args = {'-p', '-'},
        isStdout = false,
        isStderr = true,
        offsetColumn = -1,
        formatPattern = { [[^.*:(\d+): (.*)$]], { line = 1, message = 2 } },
        securities = { undefined = 'error' },
      },
      markdownlint = {
        sourceName = 'markdownlint',
        command = 'markdownlint',
        args = {'--stdin'},
        isStderr = true,
        formatPattern = {
          [[^.*?:\s?(\d+)(:(\d+)?)?\s(MD\d{3}\/[A-Za-z0-9-/]+)\s(.*)$]],
          { line = 1, column = 3, message = 4 }
        },
        securities = { undefined = 'hint' },
      },
      mix_credo = {
        sourceName = 'mix_credo',
        command = 'mix',
        args = { 'credo', 'suggest', '--format', 'flycheck', '--read-from-stdin' },
        formatPattern = {
          [[^[^ ]+?:(\d+)(:(\d+))?:\s+([^ ]+):\s+(.*)(\r|\n)*$]],
          { line = 1, column = 3, security = 4, message = 5 }
        },
        securities = { F = 'warning', C = 'warning', D = 'info', R = 'info' },
      },
      mypy = {
        sourceName = 'mypy',
        command = 'mypy',
        args = {
          '--no-color-output',
          '--no-error-summary',
          '--show-column-numbers',
          '--follow-imports=silent',
          '--ignore-missing-imports',
          '%file',
        },
        formatPattern = {
          [[^.*:(\d+?):(\d+?): ([a-z]+?): (.*)$]],
          { line = 1, column = 2, security = 3, message = 4 }
        },
        securities = { note = 'hint', error = 'error' },
      },
      phpcs = {
        sourceName = 'phpcs',
        command = './vendor/bin/phpcs',
        args = { '--standard=PSR2', '--report=emacs', '-s', '-' },
        rootPatterns = { 'composer.json', 'composer.lock', 'vendor', '.git' },
        formatPattern = {
          [[^.*:(\d+):(\d+):\s+(.*)\s+-\s+(.*)(\r|\n)*$]],
          { line = 1, column = 2, security = 3, message = 4 }
        },
        securities = { warning = 'warning', error = 'error' },
      },
      phpstan = {
        sourceName = 'phpstan',
        command = './vendor/bin/phpstan',
        args = { 'analyze', '--error-format', 'raw', '--no-progress', '%file' },
        rootPatterns = { 'composer.json', 'composer.lock', 'vendor', '.git' },
        formatPattern = { [[^[^:]+:(\d+):(.*)(\r|\n)*$]], { line = 1, message = 2 } }
      },
      proselint = {
        sourceName = 'proselint',
        command = 'proselint',
        args = {'--json'},
        parseJson = {
          errorsRoot = 'data.errors',
          line = 'line',
          column = 'column',
          security = 'severity',
          message = '${message} (${check})',
        },
        securities = { warning = 'warning' },
      },
      pylint = {
        sourceName = 'pylint',
        command = 'pylint',
        args = { '--output-format=json', '--score=no', '%file' },
        rootPatterns = { '.git', 'pyproject.toml', 'setup.py' },
        offsetColumn = 1,
        parseJson = {
          line = 'line',
          column = 'column',
          security = 'type',
          message = '${message} (${message-id}:${symbol})',
        },
        securities = {
          informational = 'hint',
          refactor = 'info',
          warning = 'warning',
          error = 'error',
          fatal = 'error',
        },
      },
      rstcheck = {
        sourceName = 'rstcheck',
        command = 'rstcheck',
        args = {'-'},
        isStdout = false,
        isStderr = true,
        offsetColumn = -1,
        formatPattern = { [[^[^:]+:(\d+): \(.+?/(\d)\) (.*)$]], { line = 1, security = 2, message = 3 } },
        securities = { ['1'] = 'info', ['2'] = 'warning', ['3'] = 'error', ['4'] = 'error' },
      },
      rst_lint = {
        sourceName = 'rst-lint',
        command = 'rst-lint',
        args = { '--format=json', '%file' },
        offsetColumn = -1,
        parseJson = { line = 'line', security = 'level', message = '${message}' },
        securities = { ['1'] = 'info', ['2'] = 'warning', ['3'] = 'error', ['4'] = 'error' },
      },
      shellcheck = {
        sourceName = 'shellcheck',
        command = 'shellcheck',
        args = { '--format=json', '-' },
        parseJson = {
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          security = 'level',
          message = '${message} (${code})',
        },
        securities = { style = 'hint', info = 'info', warning = 'warning', error = 'error' },
      },
      spectral = {
        sourceName = 'spectral',
        command = 'spectral',
        args = { 'lint', '--ignore-unknown-format', '-q', '-f', 'json' },
        parseJson = {
          line = 'range.start.line',
          column = 'range.start.character',
          endLine = 'range.end.line',
          endColumn = 'range.end.character',
          security = 'severity',
          message = '${message} (${code})',
        },
        securities = { ['1'] = 'warning', ['2'] = 'error' },
      },
      sqlint = {
        sourceName = 'sqlint',
        command = 'sqlint',
        formatPattern = {
          [[^stdin:(\d+):(\d+):([^ ]+) (.*)$]],
          { line = 1, column = 2, security = 3, message = 4 }
        },
        securities = { WARNING = 'warning', ERROR = 'error' },
      },
      standard = {
        sourceName = 'standard',
        command = './node_modules/.bin/standard',
        args = { '--stdin', '--verbose' },
        rootPatterns = {'.git'},
        formatPattern = {
          [[^\s*<\w+>:(\d+):(\d+):\s+(.*)(\r|\n)*$]],
          { line = 1, column = 2, message = 3 }
        },
      },
      stylelint = {
        sourceName = 'stylelint',
        command = './node_modules/.bin/stylelint',
        args = { '--formatter', 'json', '--stdin-filename', '%filepath' },
        rootPatterns = {'.git'},
        parseJson = {
          errorsRoot = '[0].warnings',
          line = 'line',
          column = 'column',
          security = 'severity',
          message = '${text}',
        },
        securities = { warning = 'warning', error = 'error' },
      },
      tidy = {
        sourceName = 'tidy',
        command = 'tidy',
        args = { '-e', '-q' },
        rootPatterns = {'.git'},
        isStderr = true,
        formatPattern = {
          [[^.*?(\d+).*?(\d+)\s+-\s+([^:]+):\s+(.*)(\r|\n)*$]],
          { line = 1, column = 2, endLine = 1, endColumn = 2, security = 3, message = 4 }
        },
        securities = { Warning = 'warning', Error = 'error' },
      },
      tlcheck = {
        sourceName = 'tlcheck',
        command = 'tl',
        args = { 'check', '%file' },
        isStderr = true,
        formatPattern = { [[^[^:]+:(\d+):(\d+): (.*)$]], { line = 1, column = 2, message = 3 } },
      },
      vint = {
        sourceName = 'vint',
        command = 'vint',
        args = { '--enable-neovim', '--json', '--style-problem', '-' },
        parseJson = {
          line = 'line_number',
          column = 'column_number',
          security = 'severity',
          message = '${description} (${policy_name})',
        },
        securities = { warning = 'warning', error = 'error', style_problem = 'hint' },
      },
      write_good = {
        sourceName = 'write-good',
        command = 'write-good',
        offsetColumn = 1,
        args = {'%tempfile'},
        formatPattern = {
          [[(.*)\s+on\s+line\s+(\d+)\s+at\s+column\s+(\d+)\s*$]],
          { line = 2, column = 3, message = 1 }
        },
        securities = { undefined = 'hint' },
      },
      xmllint = {
        sourceName = 'xmllint',
        command = 'xmllint',
        args = { '--noout', '-' },
        isStdout = false,
        isStderr = true,
        offsetColumn = -1,
        formatPattern = {
          [[^[^:]+:(\d+):\s*(([^:]+)\s*:.*)$]],
          { line = 1, security = 3, message = 2 }
        },
        securities = { warning = 'warning' },
      },
      xo = {
        sourceName = 'xo',
        command = 'xo',
        rootPatterns = { 'package.json', '.git' },
        args = { '--reporter', 'json', '--stdin', '--stdin-filename', '%filepath' },
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          security = 'severity',
          message = '${message} (${ruleId})',
        },
        securities = { ['1'] = 'warning', ['2'] = 'error' },
      },
      yamllint = {
        sourceName = 'yamllint',
        command = 'yamllint',
        args = { '-f', 'parsable', '-' },
        formatPattern = {
          -- NOTE there's a decent change that this is wrong
          [[^.*?:(\d+):(\d+): \[(.*?)] (.*) \((.*)\)]],
          { line = 1, column = 2, endLine = 1, endColumn = 2, security = 3, message = 4, code = 5 }
        },
        securities = { warning = 'warning', error = 'error' },
      },
      zsh = {
        'shellcheck',
      },
    },
    filetypes = {
      asciidoc = {
        'alex_text',
        'languagetool',
        'proselint',
        'write_good',
      },
      bats = {'shellcheck'},
      cmake = {'cmakelint'},
      css = {
        'csslint',
        'stylelint'
      },
      dockerfile = {'hadolint'},
      elixir = {'mix_credo'},
      fish = {'fish'},
      fountain = {'proselint'},
      gitcommit = {'gitlint'},
      graphql = {'eslint'},
      html = {
        'alex_html',
        'proselint',
        'tidy',
        'write_good',
      },
      javascript = {
        'eslint',
        'jshint',
        'standard',
        'xo',
      },
      json = {
        'jsonlint',
        'spectral',
      },
      less = {'stylelint'},
      lua = {
        'luac',
        'luacheck',
      },
      mail = {
        'alex_text',
        'languagetool',
        'proselint',
      },
      markdown = {
        'alex',
        'languagetool',
        'markdownlint',
        'proselint',
        'write_good',
      },
      nroff = {
        'alex_text',
        'proselint',
        'write_good',
      },
      php = {
        'phpcs',
        'phpstan',
      },
      po = {
        'alex',
        'proselint',
        'write_good',
      },
      pod = {
        'alex',
        'proselint',
        'write_good',
      },
      python = {
        'mypy',
        'pylint',
      },
      rst = {
        'alex_text',
        'proselint',
        'rstcheck',
        'rst_lint',
        'write_good',
      },
      sass = {'stylelint'},
      scss = {'stylelint'},
      stylus = {'stylelint'},
      sugarcss = {'stylelint'},
      sh = {
        'bashate',
        'shellcheck',
      },
      sql = {'sqlint'},
      teal = {'tlcheck'},
      tex = {
        'alex_text',
        'proselint',
        'write_good',
      },
      texinfo = {
        'alex_text',
        'proselint',
        'write_good',
      },
      typescript = {
        'eslint',
        'standard',
        'xo',
      },
      vimwiki = {
        'alex_text',
        'languagetool',
        'proselint',
        'write_good',
      },
      vue = {'eslint'},
      xhtml = {
        'alex_text',
        'proselint',
        'write_good',
      },
      xml = {'xmllint'},
      yaml = {
        'spectral',
        'yamllint',
      },
      zsh = {'zsh'},
    },
    formatters = {
      autopep8 = { command = 'autopep8', args = {'-'} },
      black = { command = 'black', args = {'--quiet', '-'} },
      cmakeformat = { command = 'cmake-format' },
      dartfmt = { command = 'dartfmt', args = {'--fix'} },
      fish_indent = { command = 'fish_indent' },
      isort = { command = 'isort', args = {'--quiet', '-'} },
      lua_format = { command = 'lua-format', args = {'-i'} },
      mix_format = { command = 'mix', args = {'format', '-'}},
      shfmt = { command = 'shfmt', args = {'-i=2', '-ci'} },
      yapf = { command = 'yapf', args = {'--quiet'} }
    },
    formatFiletypes = {
      cmake = 'cmakeformat',
      dart = 'dartfmt',
      elixir = 'mix_format',
      lua = 'lua_format',
      sh = 'shfmt'
    },
  },
}
