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
lspconfig.diagnosticls.setup(require('user.cfg.lsp.diagnosticls'):setup(on_attach))
