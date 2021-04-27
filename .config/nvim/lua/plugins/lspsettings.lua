local lsp = vim.lsp
local configs = require('lspconfig')
local util = require('lspconfig/util')
local status = require('lsp-status')

-- Handlers
lsp.handlers['textDocument/typeDefinition'] = require('lsputil.locations').typeDefinition_handler
lsp.handlers['textDocument/implementation'] = require('lsputil.locations').implementation_handler

-- Status
status.register_progress()
status.config {
  indicator_errors = '',
  indicator_warnings = '',
  indicator_info = '',
  indicator_hint = '',
  select_symbol = function(cursor_pos, symbol)
    if symbol.valueRange then
      local value_range = {
        ['start'] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[1])},
        ['end'] = {character = 0, line = vim.fn.byte2line(symbol.valueRange[2])},
      }
      return require('lsp-status.util').in_range(cursor_pos, value_range)
    end
  end,
  current_function = true,
}

-- Client filter - used to automatically turn off on_attach stuff for certain servers
local server_filter = {
  cursorline = Set {
    'diagnosticls', 'vsc_alex', 'vsc_textlint', 'eslint_lsp', 'vsc_jshint', 'vsc_spectral',
    'vsc_stylelint',
  },
}

-- Setup function
local function on_attach(client)
  local nnor, vnor = vim.keymap.nnoremap, vim.keymap.vnoremap
  local ft = vim.bo.filetype
  local caps = client.resolved_capabilities
  local ts_has_locals = require('nvim-treesitter.query').has_locals(ft)
  status.on_attach(client)

  if caps.hover then
    nnor {'<Leader>hh', [[<Cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true}
    if ft ~= 'vim' then nnor {'K', [[<Cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = true} end
  end

  if caps.find_references then
    nnor {'gh', [[<Cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true}
    nnor {'gr', [[<Cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = true}
  end

  if caps.signature_help then
    nnor {'gs', [[<Cmd>Lspsaga signature_help<CR>]], silent = true, buffer = true}
  end

  if caps.code_action then
    nnor {'ca', [[<Cmd>Lspsaga code_action<CR>]], silent = true, buffer = true}
    vnor {'ca', [[:<C-u>Lspsaga range_code_action<CR>]], silent = true, buffer = true}
  end

  if caps.rename then
    nnor {'<Leader>rn', [[<Cmd>Lspsaga rename<CR>]], silent = true, buffer = true}
  end

  if caps.goto_definition then
    nnor {'gd', [[<Cmd>Lspsaga preview_definition<CR>]], silent = true, buffer = true}
  end

  if caps.type_definition then
    nnor {'gy', [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]], silent = true, buffer = true}
  end

  if caps.implementation then
    nnor {'gi', [[<Cmd>lua vim.lsp.buf.implementation()<CR>]], silent = true, buffer = true}
  end

  if caps.document_symbol then
    -- Vista.vim support
    if vim.g.vista_executive_for then
      local vista_exec = 'vista_' .. ft .. '_executive'
      vim.g[vista_exec] = (vim.g[vista_exec] or vim.g.vista_executive_for[ft] or 'nvim_lsp')
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

  if caps.document_highlight and not ts_has_locals then
    -- Tree-sitter does this better
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  elseif not ts_has_locals and not server_filter.cursorline[client.config.name] then
    -- If tree-sitter & lsp can't handle stuff, defer document highlighting to nvim-cursorline.
    require('user.cfg.nvim-cursorline').on_attach()
  end

  -- Diagnostics are probably always available
  nnor {'<Leader>cd', [[<Cmd>Lspsaga show_line_diagnostics<CR>]], silent = true, buffer = true}
  nnor {'[e', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true}
  nnor {'[g', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = true}
  nnor {']e', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true}
  nnor {']g', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = true}

end

local capabilities = lsp.protocol.make_client_capabilities()
vim.tbl_deep_extend('keep', capabilities, status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

util.default_config = vim.tbl_extend('force', util.default_config,
                                     {capabilities = capabilities, on_attach = on_attach})

-- JSON Config support
require('nlspsettings').setup()

for _, S in ipairs({
  'bashls', 'cmake', 'dockerls', 'dotls', 'fortls', 'gopls', 'html', 'lsp4xml', 'mypyls', 'pyright',
  'sqls', 'taplo', 'texlab', 'vimls', 'yamlls', 'vsc_alex', 'tealls', 'vsc_textlint', 'eslint_lsp',
  'vsc_jshint', 'vsc_spectral',
  -- jedi-language-server has a really annoying code action that i'd like to avoid
  -- rust_analyzer is set up elsewhere.
  -- vsc_stylelint isn't really needed
}) do configs[S].setup({}) end

configs.ccls.setup {
  init_options = {
    compilationDatabaseDirectory = 'build',
    index = {threads = 0},
    cache = {directory = '.ccls-cache'},
    clang = {resourceDir = '/usr/lib64/clang/11'},
    highlight = {lsRanges = true},
  },
  commands = {
    LspFormat = {function() lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line('$'), 0}) end},
  },
}

configs.clangd.setup {
  handlers = status.extensions.clangd.setup(),
  init_options = {clangdFileStatus = true},
}

configs.cssls.setup {filetypes = {'css', 'sass', 'scss', 'less'}}

configs.denols.setup {root_dir = require('user.cfg.lsp.utils').tsdetect('deno')}

configs.jsonls.setup {
  filetypes = {'json', 'jsonc'},
  settings = {json = {schemas = require('nlspsettings.jsonls').get_default_schemas()}},
}

configs.sqlls.setup {cmd = {'sql-language-server', 'up', '--method', 'stdio'}}

configs.sumneko_lua.setup {cmd = {'lua-language-server'}}

configs.tsserver.setup {root_dir = require('user.cfg.lsp.utils').tsdetect('node')}

-- The giant language servers - diagnosticls & efm
-- more linters are @ https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
configs.efm.setup {filetypes = {'eruby', 'make', 'zsh'}}
configs.diagnosticls.setup(require('user.cfg.lsp.diagnosticls'):setup())
