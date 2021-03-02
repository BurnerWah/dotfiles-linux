local lspconfig = require 'lspconfig'
local lsp_status = require 'lsp-status'
lsp_status.register_progress()
lsp_status.config {
  indicator_errors = '',
  indicator_warnings = '',
  indicator_info = '',
  indicator_hint = '',
  -- indicator_ok = 'Ok',
  select_symbol = function(cursor_pos, symbol)
    if symbol.valueRange then
      local value_range = {
        ["start"] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[1])},
        ["end"] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[2])},
      }
      return require("lsp-status.util").in_range(cursor_pos, value_range)
    end
  end,
  current_function = true,
}

local function on_attach(client)
  local nnor, vnor = vim.keymap.nnoremap, vim.keymap.vnoremap
  local filetype = vim.bo.filetype
  local client_caps = client.resolved_capabilities
  lsp_status.on_attach(client)

  if client_caps.hover then
    nnor {'<Leader>hh', [[<Cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true}
    if filetype ~= 'vim' then
      nnor {'K', [[<Cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true}
    end
  end

  if client_caps.find_references then
    nnor {'gh', [[<Cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true}
    nnor {'gr', [[<Cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true}
  end

  if client_caps.signature_help then
    nnor {'gs', [[<Cmd>Lspsaga signature_help<CR>]], silent = true, buffer = true}
  end

  if client_caps.code_action then
    vim.cmd [[autocmd init CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()]]
    nnor {'ca', [[<Cmd>Lspsaga code_action<CR>]], silent = true, buffer = true}
    nnor {'<Leader>ac', [[<Cmd>Lspsaga code_action<CR>]], silent = true, buffer = true}
    vnor {'ca', [[:<C-u>Lspsaga range_code_action<CR>]], silent = true, buffer = true}
  end

  if client_caps.rename then
    nnor {'<Leader>rn', [[<Cmd>Lspsaga rename<CR>]], silent = true, buffer = true}
  end

  if client_caps.goto_definition then
    nnor {'gd', [[<Cmd>Lspsaga preview_definition<CR>]], silent = true, buffer = true}
  end

  if client_caps.document_symbol then
    -- Vista.vim support
    if vim.g.vista_executive_for then
      local vista_exec = 'vista_' .. filetype .. '_executive'
      vim.g[vista_exec] = (vim.g[vista_exec] or vim.g.vista_executive_for[filetype] or 'nvim_lsp')
    end
    -- Assurance that lsp-status will work
    vim.api.nvim_exec([[
    autocmd! lsp_aucmds CursorHold
    augroup lsp_current_function
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua require("lsp-status").update_current_function()
    augroup END
    ]], false)
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
  nnor {'<Leader>cd', [[<Cmd>Lspsaga show_line_diagnostics<CR>]], silent = true, buffer = true}
  nnor {'[e', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true}
  nnor {'[g', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true}
  nnor {']e', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true}
  nnor {']g', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true}

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.tbl_deep_extend('keep', capabilities, lsp_status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config,
                                               {capabilities = capabilities, on_attach = on_attach})

local simple_servers = {
  'bashls', 'cmake', 'denols', 'dockerls', 'dotls', 'fortls', 'html', 'jedi_language_server',
  'lsp4xml', 'mypyls', 'pyright', 'rust_analyzer', 'sqls', 'taplo', 'texlab', 'tsserver', 'vimls',
  'vsc_alex',
}
for _, server in ipairs(simple_servers) do lspconfig[server].setup {} end

local url = {
  parse = function(input)
    input = input:gsub([[^gh:(.*):(.*):(.+)$]], [[https://github.com/%1/raw/%2/%3]])
    return input
  end,
}

lspconfig.ccls.setup {
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
lspconfig.clangd.setup {
  handlers = lsp_status.extensions.clangd.setup(),
  init_options = {clangdFileStatus = true},
}
lspconfig.cssls.setup {filetypes = {'css', 'sass', 'scss', 'less'}} -- Missing sass ft by default
lspconfig.gopls.setup {
  settings = {
    gopls = {analyses = {unusedparams = true}, staticcheck = true, usePlaceholders = true},
  },
}
lspconfig.jsonls.setup {
  filetypes = {'json', 'jsonc'},
  settings = {json = {schemas = require('user.data.gen.generated_schemas')}}, -- Schemas are generated now
  commands = {
    LspFormat = {function() vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0}) end},
  },
}
lspconfig.pyls_ms.setup {
  -- I'd like to disable hover for this since it's not very useful
  cmd = {vim.fn.expand('~/.local/libexec/pyls-ms/Microsoft.Python.LanguageServer')},
  handlers = lsp_status.extensions.pyls_ms.setup(),
  settings = {python = {workspaceSymbols = {enabled = true}, autoComplete = {addBrackets = true}}},
}
lspconfig.sqlls.setup {cmd = {'sql-language-server', 'up', '--method', 'stdio'}}
lspconfig.sumneko_lua.setup {
  cmd = {'lua-language-server'},
  settings = {
    Lua = {
      runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
      completion = {callSnippet = 'Replace'}, -- Prefer completing snippets
      diagnostics = {
        globals = {'vim', 'packer_plugins'},
        disable = {'lowercase-global', 'undefined-global'},
      },
      hint = {enable = true, setType = true},
      telemetry = {enable = false},
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.stdpath('data') .. '/site/lua_types'] = true,
          [vim.fn.stdpath('data') .. '/site/vim_types'] = true,
          -- ['/usr/share/lua/5.4'] = true,
        },
      },
      intelliSense = {searchDepth = 4},
    },
  },
}
lspconfig.yamlls.setup {
  settings = {
    yaml = {
      format = {singleQuote = true},
      schemas = {
        [url.parse 'gh:mattn/efm-langserver:master:schema.json'] = '/efm-langserver/config.yaml',
      },
    },
  },
}

-- The giant language servers - diagnosticls & efm
-- more linters are @ https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
lspconfig.efm.setup {filetypes = {'eruby', 'make', 'zsh'}}
lspconfig.diagnosticls.setup(require('user.cfg.lsp.diagnosticls'):setup())
