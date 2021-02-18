local lspconfig = require 'lspconfig'

local on_attach = function(client)
  local nnor, vnor = vim.keymap.nnoremap, vim.keymap.vnoremap
  local filetype = vim.bo.filetype
  local client_caps = client.resolved_capabilities

  if client_caps.hover then
    nnor {'<leader>hh', [[<cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true}
    if filetype ~= 'vim' then
      nnor {'K', [[<cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true}
    end
  end

  if client_caps.find_references then
    nnor {'gh', [[<cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true}
    nnor {'gr', [[<cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true}
  end

  if client_caps.signature_help then
    nnor {'gs', [[<cmd>Lspsaga signature_help<CR>]], silent = true, buffer = true}
  end

  if client_caps.code_action then
    vim.cmd [[autocmd init CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()]]
    nnor {'ca', [[<cmd>Lspsaga code_action<CR>]], silent = true, buffer = true}
    nnor {'<leader>ac', [[<cmd>Lspsaga code_action<CR>]], silent = true, buffer = true}
    vnor {'ca', [[:<C-U>Lspsaga range_code_action<CR>]], silent = true, buffer = true}
  end

  if client_caps.rename then
    nnor {'<leader>rn', [[<cmd>Lspsaga rename<CR>]], silent = true, buffer = true}
  end

  if client_caps.goto_definition then
    nnor {'gd', [[<cmd>Lspsaga preview_definition<CR>]], silent = true, buffer = true}
  end

  if client_caps.document_symbol then
    -- Vista.vim support
    if vim.g.vista_executive_for then
      local vista_exec = 'vista_' .. filetype .. '_executive'
      vim.g[vista_exec] = (vim.g[vista_exec] or vim.g.vista_executive_for[filetype] or 'nvim_lsp')
    end
  end

  if client_caps.document_highlight then
    -- Tree-sitter does this better
    if not require('nvim-treesitter.query').has_locals(filetype) then
      vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]], false)
    end
  end

  -- Diagnostics are probably always available
  nnor {'<leader>cd', [[<cmd>Lspsaga show_line_diagnostics<CR>]], silent = true, buffer = true}
  nnor {'[e', [[<cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true}
  nnor {'[g', [[<cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true}
  nnor {']e', [[<cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true}
  nnor {']g', [[<cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true}

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local simple_servers = {
  'bashls', 'cmake', 'denols', 'dotls', 'dockerls', 'fortls', 'html', 'pyright', 'sqls', 'taplo',
  'tsserver', 'vimls',
}
for _, server in ipairs(simple_servers) do
  lspconfig[server].setup {on_attach = on_attach, capabilities = capabilities}
end

local url = {
  parse = function(input)
    input = input:gsub([[^gh:(.*):(.*):(.+)$]], [[https://github.com/%1/raw/%2/%3]])
    return input
  end,
  gh_raw = [[https://github.com/%s/raw/%s/%s]],
  schema = [[https://json.schemastore.org/%s]],
}

lspconfig.ccls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    compilationDatabaseDirectory = 'build',
    index = {threads = 0},
    cache = {directory = '.ccls-cache'},
    clang = {resourceDir = '/usr/lib64/clang/11'},
    highlight = {lsRanges = true},
  },
  commands = {
    LspFormat = {function() vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0}) end},
  },
}
lspconfig.cssls.setup {
  -- Missing sass filetype by default
  filetypes = {'css', 'sass', 'scss', 'less'},
  on_attach = on_attach,
  capabilities = capabilities,
}
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {analyses = {unusedparams = true}, staticcheck = true, usePlaceholders = true},
  },
}
local function gen_schema(match, schema)
  schema = url.parse(schema)
  return {
    fileMatch = ((type(match) == 'table') and match or {match}),
    url = (schema:find('^https?://') and schema or url.schema:format(schema)),
  }
end
lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {'json', 'jsonc'},
  settings = {
    json = {
      schemas = {
        -- Really wish that this supported schemastore out of the box
        gen_schema('*.ipynb', 'gh:jupyter/nbformat:master:nbformat/v4/nbformat.v4.schema.json'),
        gen_schema('.bootstraprc', 'bootstraprc'), gen_schema('.bowerrc', 'bowerrc'),
        gen_schema('.csslintrc', 'csslintrc'), gen_schema('.jsbeautifyrc', 'jsbeautifyrc'),
        gen_schema('.jshintrc', 'jshintrc'), gen_schema('.jsinspectrc', 'jsinspectrc'),
        gen_schema('.modernizrrc', 'modernizrrc'), gen_schema('coffeelint.json', 'coffeelint'),
        gen_schema('jsconfig.json', 'jsconfig'), gen_schema('package.json', 'package'),
        gen_schema('tsconfig.json', 'tsconfig'), gen_schema('tslint.json', 'tslint'),
        gen_schema({'.babelrc', 'babel.config.json'}, 'babelrc'),
        gen_schema({'.bower.json', 'bower.json'}, 'bower'),
        gen_schema({'.eslintrc', '.eslintrc.json'}, 'eslintrc'),
        gen_schema({'.mocharc.json', '.mocharc.jsonc'}, 'mocharc'),
        gen_schema({'.prettierrc', '.prettierrc.json'}, 'prettierrc'),
      },
    },
  },
  commands = {
    LspFormat = {function() vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0}) end},
  },
}
lspconfig.pyls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pyls = {
      configurationSources = {'pyflakes', 'pycodestyle'},
      plugins = {
        jedi_completion = {enabled = true},
        jedi_hover = {enabled = false},
        jedi_references = {enabled = true},
        jedi_signature_help = {enabled = true},
        jedi_symbols = {enabled = true, all_scopes = true},
        mccabe = {enabled = true, threshold = 15},
        preload = {enabled = true},
        pycodestyle = {enabled = false},
        pydocstyle = {enabled = false},
        pyflakes = {enabled = false},
        rope_completion = {enabled = true},
        yapf = {enabled = true},
      },
    },
  },
  commands = {
    LspFormat = {function() vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0}) end},
  },
}
lspconfig.rls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {rust = {clippy_preference = 'on'}},
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
      runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
      completion = {callSnippet = 'Replace'}, -- Prefer completing snippets
      diagnostics = {globals = {'vim', 'packer_plugins'}, disable = {'lowercase-global'}},
      hint = {enable = true},
      telemetry = {enable = false},
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.stdpath('data') .. '/site/lua_types'] = true,
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
      format = {singleQuote = true},
      schemas = {
        -- [url.gh_raw:format('mattn/efm-langserver', 'master', 'schema.json')] = '/efm-langserver/config.yaml',
        [url.parse 'gh:mattn/efm-langserver:master:schema.json'] = '/efm-langserver/config.yaml',
      },
    },
  },
}

-- The giant language servers - diagnosticls & efm
-- more linters are @ https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
lspconfig.efm.setup {
  filetypes = {'eruby', 'make', 'zsh'},
  capabilities = capabilities,
  on_attach = on_attach,
}

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
local security_gen = {
  docutils = {INFO = 'info', WARNING = 'warning', ERROR = 'error', SEVERE = 'error'},
}
local linter = {
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
lspconfig.diagnosticls.setup {
  filetypes = {
    'asciidoc', 'bats', 'c', 'cmake', 'cpp', 'css', 'dockerfile', 'elixir', 'fountain', 'fish',
    'gitcommit', 'graphql', 'html', 'javascript', 'json', 'jsonc', 'less', 'lua', 'mail',
    'markdown', 'nroff', 'php', 'po', 'pod', 'python', 'rst', 'sass', 'scss', 'stylus', 'sugarcss',
    'sh', 'sql', 'teal', 'tex', 'texinfo', 'typescript', 'vimwiki', 'vue', 'xhtml', 'xml', 'yaml',
    'zsh',
  },
  on_attach = on_attach,
  init_options = {
    linters = {
      alex = linter.alex(),
      alex_text = linter.alex '--text',
      alex_html = linter.alex '--html',
      bashate = linter.generic {
        {'bashate', '-i', 'E003', '%tempfile'},
        pattern = {[[^.+?:(\d+):(\d+): ((E\d+) (.*))$]], {line = 1, column = 2, message = 3}},
        security = 'hint',
      },
      cmakelint = linter.generic {
        {'cmakelint', '%file'},
        pattern = fmt.basic(true),
        security = 'warning',
      },
      cppcheck_c = linter.cppcheck('c'),
      cppcheck_cpp = linter.cppcheck('c++'),
      csslint = linter.json {
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
      eslint = linter.json {
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
      fish = linter.generic {
        {'fish', '-n', '%file'},
        stream = 'stderr',
        pattern = {[[^.*\(line (\d+)\): (.*)$]], {line = 1, message = 2}},
      },
      flawfinder = linter.generic {
        {'flawfinder', '-CDQS', '-'},
        pattern = {
          [[^.+?:(\d+):(\d+):\s+\[(\d+)\][^:]+?:(.+)$]],
          {line = 1, column = 2, security = 3, message = 4},
        },
        securities = {['0'] = 'hint', ['1'] = 'warning'},
      },
      gitlint = linter.generic {
        {'gitlint', '--msg-filename', '%tempfile'},
        stream = 'stderr',
        security = 'warning',
      },
      hadolint = linter.json {
        {'hadolint', '-f', 'json', '-'},
        roots = '.hadolint.yaml',
        parse = {
          line = 'line',
          column = 'column',
          security = 'level',
          message = '${message} (${code})',
        },
        securities = {style = 'hint', info = 'info', warning = 'warning', error = 'error'},
      },
      jshint = linter.generic {
        {'jshint', '--reporter=unix', '--extract=auto', '--filename', '%filepath', '-'},
        pattern = fmt.unix(true),
        security = 'hint',
      },
      jsonlint = linter.generic {
        {'jsonlint', '--compact', '-'},
        stream = 'stderr',
        pattern = {[[^line (\d+), col (\d+), (.*)$]], {line = 1, column = 2, message = 3}},
      },
      jq = linter.generic {
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
      luacheck = linter.generic {
        {'luacheck', '--formatter=plain', '--codes', '--ranges', '-', '-g'},
        pattern = {
          [[^.+?:(\d+):(\d+)-(\d+): (\(([WE])\d+\) .*)$]],
          {line = 1, column = 2, endColumn = 3, security = 5, message = 4},
        },
        securities = {W = 'warning', E = 'error'},
      },
      luac = linter.generic {{'luac', '-p', '-'}, stream = 'stderr', pattern = fmt.basic(true)},
      markdownlint = linter.generic {
        {'markdownlint', '--stdin'},
        stream = 'both',
        pattern = {
          [[^.*?: ?(\d+)(?::(\d+))? ((?:MD\d{3}\/[\w-/]+) .*)$]],
          {line = 1, column = 2, message = 3},
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
      mypy = linter.generic {
        'mypy',
        args = {
          '--no-color-output', '--no-error-summary', '--show-column-numbers',
          '--follow-imports=silent', '--ignore-missing-imports', '%file',
        },
        pattern = {
          [[^.*:(\d+?):(\d+?): ([a-z]+?): (.*)$]],
          {line = 1, column = 2, security = 3, message = 4},
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
      proselint = linter.json {
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
      pylint = linter.json {
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
      rstcheck = linter.generic {
        {'rstcheck', '-'},
        stream = 'stderr',
        pattern = {[[^.+?:(\d+): \((.+?)/\d\) (.*)$]], {line = 1, security = 2, message = 3}},
        securities = security_gen.docutils,
      },
      rst_lint = linter.json {
        {'rst-lint', '--format=json', '%file'},
        parse = {line = 'line', security = 'type', message = '${message}'},
        securities = security_gen.docutils,
      },
      shellcheck = linter.json {
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
      spectral = linter.json {
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
      sqlint = linter.generic {
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
      stylelint = linter.json {
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
      tlcheck = linter.generic {
        'tlcheck',
        cmd = 'tl',
        args = {'check', '%file'},
        stream = 'both',
        pattern = fmt.unix(true),
      },
      vint = linter.json {
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
      xmllint = linter.generic {
        {'xmllint', '--noout', '-'},
        stream = 'stderr',
        pattern = {[[^[^:]+:(\d+):\s*(([^:]+)\s*:.*)$]], {line = 1, security = 3, message = 2}},
        securities = {warning = 'warning'},
      },
      xo = linter.json {
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
      yamllint = linter.generic {
        {'yamllint', '-f', 'parsable', '-'},
        pattern = {
          [[^.*?:(\d+):(\d+): \[(.*?)] (.*)$]], {line = 1, column = 2, security = 3, message = 4},
        },
        securities = {warning = 'warning', error = 'error'},
      },
      zsh = linter.generic {
        'zsh',
        cmd = 'linter_run_zsh.sh',
        args = {'%file'},
        pattern = fmt.basic(true),
      },
    },
    filetypes = {
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
    },
  },
}
