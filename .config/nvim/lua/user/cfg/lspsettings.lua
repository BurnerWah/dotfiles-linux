local lspconfig = require'lspconfig'

local on_attach = function(client)
  local nnoremap, vnoremap = vim.keymap.nnoremap, vim.keymap.vnoremap
  local filetype = vim.bo.filetype

  if client.resolved_capabilities.hover then
    nnoremap { '<leader>hh', [[<cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true }
    if filetype ~= 'vim' then
      nnoremap { 'K', [[<cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true }
    end
  end

  if client.resolved_capabilities.find_references then
    nnoremap { 'gh', [[<cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true }
    nnoremap { 'gr', [[<cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true }
  end

  if client.resolved_capabilities.signature_help then
    nnoremap { 'gs', [[<cmd>Lspsaga signature_help<CR>]], silent = true, buffer = true }
  end

  if client.resolved_capabilities.code_action then
    vim.cmd [[autocmd init CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()]]
    nnoremap { 'ca', [[<cmd>Lspsaga code_action<CR>]], silent = true, buffer=true }
    nnoremap { '<leader>ac', [[<cmd>Lspsaga code_action<CR>]], silent = true, buffer=true }
    vnoremap { 'ca', [[:<C-U>Lspsaga range_code_action<CR>]], silent = true, buffer=true }
  end

  if client.resolved_capabilities.rename then
    nnoremap { '<leader>rn', [[<cmd>Lspsaga rename<CR>]], silent = true, buffer=true }
  end

  if client.resolved_capabilities.goto_definition then
    nnoremap { 'gd', [[<cmd>Lspsaga preview_definition<CR>]], silent = true, buffer = true }
  end

  if client.resolved_capabilities.document_symbol then
    -- Vista.vim support
    if vim.g.vista_executive_for then
      local vista_exec = 'vista_'..filetype..'_executive'
      vim.g[vista_exec] = (vim.g[vista_exec] or vim.g.vista_executive_for[filetype] or 'nvim_lsp')
    end
  end

  -- Diagnostics are probably always available
  nnoremap { '<leader>cd', [[<cmd>Lspsaga show_line_diagnostics<CR>]], silent = true, buffer = true }
  nnoremap { '[e', [[<cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true }
  nnoremap { '[g', [[<cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true }
  nnoremap { ']e', [[<cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true }
  nnoremap { ']g', [[<cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true }

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local simple_servers = {
  'bashls',
  'cmake',
  'cssls',
  'denols',
  'dotls',
  'dockerls',
  'fortls',
  'html',
  -- 'jedi_language_server',
  'pyright',
  'sqls',
  'taplo',
  'tsserver',
  'vimls',
}
for _, server in ipairs(simple_servers) do
  lspconfig[server].setup { on_attach = on_attach, capabilities = capabilities }
end

local url = {
  gh_raw = [[https://github.com/%s/raw/%s/%s]],
}

lspconfig.ccls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    compilationDatabaseDirectory = 'build',
    index = { threads = 0 },
    cache = { directory = '.ccls-cache' },
    clang = { resourceDir = '/usr/lib64/clang/11' },
    highlight = { lsRanges = true },
  },
  commands = {
    LspFormat = {
      function() vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0}) end
    },
  },
}
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
}
lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  commands = {
    LspFormat = {
      function() vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0}) end
    },
  },
}
lspconfig.pyls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pyls = {
      configurationSources = { 'pyflakes', 'pycodestyle' },
      plugins = {
        jedi_completion = { enabled = true },
        jedi_hover = { enabled = false },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true, all_scopes = true },
        mccabe = { enabled = true, threshold = 15 },
        preload = { enabled = true },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pyflakes = { enabled = false },
        rope_completion = { enabled = true },
        yapf = { enabled = true },
      }
    }
  },
  commands = {
    LspFormat = {
      function() vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0}) end
    },
  },
}
lspconfig.rls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    rust = {
      clippy_preference = 'on',
    },
  },
}
lspconfig.sqlls.setup {
  cmd = {'sql-language-server', 'up', '--method', 'stdio'},
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.sumneko_lua.setup {
  cmd = {'lua-language-server'},
  on_attach = on_attach,
  capabilities = capabilities,
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
lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      format = { singleQuote = true },
      schemas = {
        [url.gh_raw:format('mattn/efm-langserver', 'master', 'schema.json')] = '/efm-langserver/config.yaml',
      },
    },
  },
}

-- The giant language servers - diagnosticls & efm
-- more linters are @ https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
lspconfig.efm.setup {
  filetypes = { 'eruby', 'make', 'zsh' },
  capabilities = capabilities,
  on_attach = on_attach,
}

local fmt = {
  basic = function(file)
    return {
      (file and [[^.+?:(\d+): (.*)$]] or [[^(\d+): (.*)$]]),
      { line = 1, message = 2 }
    }
  end,
  unix = function(file)
    return {
      ([[^%s(\d+):(\d+): (.*)$]]):format((file and '.+?' or '')),
      { line = 1, column = 2, message = 3 }
    }
  end,
}
local security_gen = {
  docutils = { INFO = 'info', WARNING = 'warning', ERROR = 'error', SEVERE = 'error' },
}
local linter = {
  generic = function(opts)
    opts.stream = (opts.stream or 'stdout')
    return {
      sourceName = (opts.name or opts[1]),
      command = (opts.cmd or opts.name or opts[1]),
      args = (opts.args or {}),
      isStdout = (opts.stream ~= 'stderr'),
      isStderr = (opts.stream ~= 'stdout'),
      formatPattern = (opts.pattern or fmt.basic()),
      securities = (opts.securities or { undefined = (opts.security or 'error') }),
    }
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
        { line = 1, column = 2, endLine = 3, endColumn = 4, message = 5 }
      },
      securities = { undefined = 'warning' },
    }
  end,
  cppcheck = function(lang)
    return {
      sourceName = 'cppcheck',
      command = 'cppcheck',
      args = {
        '--quiet',
        ('--language=%s'):format(lang),
        '--enable=style',
        '--template',
        '{line}:{column}: {severity}:{inconclusive:inconclusive:} {message} [{id}]',
        '%tempfile', -- This might be bad
        -- NOTE ALE has a project folder but I think I'd need a wrapper for that
      },
      isStderr = true,
      formatPattern = {
        [[^(\d+):(\d+): (\w+): (.*)$]],
        { line = 1, column = 2, security = 3, message = 4 }
      },
      securities = { style = 'hint', warning = 'warning', error = 'error' },
    }
  end,
}
lspconfig.diagnosticls.setup {
  filetypes = {
    'asciidoc',
    'bats',
    'c',
    'cmake',
    'cpp',
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
  -- capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    linters = {
      alex = linter.alex(),
      alex_text = linter.alex('--text'),
      alex_html = linter.alex('--html'),
      bashate = linter.generic {
        'bashate',
        args = {'-i', 'E003', '%tempfile'},
        pattern = { [[^.+?:(\d+):(\d+): ((E\d+) (.*))$]], { line = 1, column = 2, message = 3 } },
        security = 'hint',
      },
      cmakelint = linter.generic {
        'cmakelint',
        args = {'%file'},
        pattern = fmt.basic(true),
        security = 'warning',
      },
      cppcheck_c = linter.cppcheck('c'),
      cppcheck_cpp = linter.cppcheck('c++'),
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
      fish = linter.generic {
        'fish',
        args = {'-n', '%file'},
        stream = 'stderr',
        pattern = { [[^.*\(line (\d+)\): (.*)$]], { line = 1, message = 2 } }
      },
      flawfinder = linter.generic {
        'flawfinder',
        args = {'-CDQS', '-'},
        pattern = {
          [[^.+?:(\d+):(\d+):\s+\[(\d+)\][^:]+?:(.+)$]],
          { line = 1, column = 2, security = 3, message = 4 },
        },
        securities = { ['0'] = 'hint', ['1'] = 'warning' }
      },
      gitlint = linter.generic {
        'gitlint',
        args = {'--msg-filename', '%tempfile'},
        stream = 'stderr',
        security = 'warning',
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
      jshint = linter.generic {
        'jshint',
        args = { '--reporter=unix', '--extract=auto', '--filename', '%filepath', '-' },
        pattern = fmt.unix(true),
        security = 'hint',
      },
      jsonlint = linter.generic {
        'jsonlint',
        args = { '--compact', '-' },
        stream = 'stderr',
        pattern = { [[^line (\d+), col (\d+), (.*)$]], { line = 1, column = 2, message = 3 } },
      },
      jq = linter.generic {
        'jq',
        args = {'.', '%file'},
        stream = 'stderr',
        pattern = {
          [[^parse error: (.+) at line (\d+), column (\d+)$]],
          { line = 2, column = 3, message = 1 }
        }
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
        securities = { undefined = 'hint' },
      },
      luacheck = linter.generic {
        'luacheck',
        args = { '--formatter=plain', '--codes', '--ranges', '-', '-g' },
        pattern = {
          [[^.+?:(\d+):(\d+)-(\d+): (\(([WE])\d+\) .*)$]],
          { line = 1, column = 2, endColumn = 3, security = 5, message = 4 }
        },
        securities = { W = 'warning', E = 'error' },
      },
      luac = linter.generic {
        'luac',
        args = {'-p', '-'},
        stream = 'stderr',
        pattern = fmt.basic(true),
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
        securities = { warning = 'hint' },
      },
      pylint = {
        sourceName = 'pylint',
        command = 'pylint',
        args = {
          '--output-format=json',
          '--score=no',
          '--disable=import-error',
          '--disable=wrong-import-order',
          '--disable=no-name-in-module',
          '%file',
        },
        rootPatterns = { '.git', 'pyproject.toml', 'setup.py' },
        offsetColumn = 1,
        parseJson = {
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
      rstcheck = linter.generic {
        'rstcheck',
        args = {'-'},
        stream = 'stderr',
        pattern = { [[^.+?:(\d+): \((.+?)/\d\) (.*)$]], { line = 1, security = 2, message = 3 } },
        securities = security_gen.docutils,
      },
      rst_lint = {
        sourceName = 'rst-lint',
        command = 'rst-lint',
        args = { '--format=json', '%file' },
        parseJson = { line = 'line', security = 'type', message = '${message}' },
        securities = security_gen.docutils,
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
      sqlint = linter.generic {
        'sqlint',
        pattern = {
          [[^.+?:(\d+):(\d+):([^ ]+) (.*)$]],
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
          -- { line = 1, column = 2, endLine = 1, endColumn = 2, security = 3, message = 4 }
          { line = 1, column = 2, security = 3, message = 4 }
        },
        securities = { Warning = 'warning', Error = 'error' },
      },
      tlcheck = linter.generic {
        'tlcheck',
        cmd = 'tl',
        args = {'check', '%file'},
        stream = 'both',
        pattern = fmt.unix(true),
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
          [[(.*) on line (\d+) at column (\d+)\s*$]],
          { line = 2, column = 3, message = 1 }
        },
        securities = { undefined = 'hint' },
      },
      xmllint = linter.generic {
        'xmllint',
        args = { '--noout', '-' },
        stream = 'stderr',
        pattern = {
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
      yamllint = linter.generic {
        'yamllint',
        args = { '-f', 'parsable', '-' },
        pattern = {
          [[^.*?:(\d+):(\d+): \[(.*?)] (.*)$]],
          { line = 1, column = 2, security = 3, message = 4 }
        },
        securities = { warning = 'warning', error = 'error' },
      },
      zsh = linter.generic {
        'zsh',
        cmd = 'linter_run_zsh.sh',
        args = {'%file'},
        pattern = fmt.basic(true),
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
      c = {
        'cppcheck_c',
        'flawfinder',
      },
      cmake = {'cmakelint'},
      cpp = {
        'cppcheck_cpp',
        'flawfinder',
      },
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
        'jq',
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
  },
}
