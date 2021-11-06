local lsp = vim.lsp
local configs = require('lspconfig')
local util = require('lspconfig/util')
local tablex, Set = require('pl.tablex'), require('pl.Set')
local lspcontainers = require('lspcontainers')

-- Client filter - used to automatically turn off on_attach stuff for certain servers
local server_filter = {
  cursorline = Set({
    'diagnosticls', 'vsc_alex', 'vsc_textlint', 'eslint_lsp', 'vsc_jshint', 'vsc_spectral',
  }),
}

-- Setup function
local function on_attach(client, bufnr)
  local winnr = vim.api.nvim_get_current_win()
  local async

  async = vim.loop.new_async(vim.schedule_wrap(function()
    local nnor, vnor = vim.keymap.nnoremap, vim.keymap.vnoremap
    local ft = vim.bo[1].filetype
    local caps = client.resolved_capabilities
    local ts_has_locals = require('nvim-treesitter.query').has_locals(ft)
    local has_wk, wk = pcall(require, 'which-key')

    if caps.hover then
      nnor({'<Leader>hh', [[<Cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = bufnr})
      if ft ~= 'vim' then
        nnor({'K', [[<Cmd>Lspsaga hover_doc<CR>]], silent = true, buffer = bufnr})
      end
    end

    if caps.find_references then
      nnor({'gh', [[<Cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = bufnr})
      nnor({'gr', [[<Cmd>Lspsaga lsp_finder<CR>]], silent = true, buffer = bufnr})
      if has_wk then
        wk.register({gr = {[[<Cmd>Lspsaga lsp_finder<CR>]], 'Find references', buffer = bufnr}})
      end
    end

    if caps.signature_help then
      nnor({'gs', [[<Cmd>Lspsaga signature_help<CR>]], silent = true, buffer = bufnr})
    end

    if caps.code_action then
      vim.wo[winnr].signcolumn = 'yes'
      nnor({'ca', [[<Cmd>Lspsaga code_action<CR>]], silent = true, buffer = bufnr})
      vnor({'ca', [[:<C-u>Lspsaga range_code_action<CR>]], silent = true, buffer = bufnr})
    end

    if caps.rename then
      nnor({'<Leader>rn', [[<Cmd>Lspsaga rename<CR>]], silent = true, buffer = bufnr})
    end

    if caps.goto_definition then
      nnor({'gd', [[<Cmd>Lspsaga preview_definition<CR>]], silent = true, buffer = bufnr})
      if has_wk then
        wk.register({
          gd = {[[<Cmd>Lspsaga preview_definition<CR>]], 'Go to definition', buffer = bufnr},
        })
      end
    end

    if caps.type_definition then
      nnor({'gy', [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]], silent = true, buffer = bufnr})
    end

    if caps.implementation then
      nnor({'gi', [[<Cmd>lua vim.lsp.buf.implementation()<CR>]], silent = true, buffer = bufnr})
    end

    if caps.document_symbol then
      -- Vista.vim support
      if vim.g.vista_executive_for then
        local vista_exec = 'vista_' .. ft .. '_executive'
        vim.g[vista_exec] = (vim.g[vista_exec] or vim.g.vista_executive_for[ft] or 'nvim_lsp')
      end
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
    nnor({'<Leader>cd', [[<Cmd>Lspsaga show_line_diagnostics<CR>]], silent = true, buffer = bufnr})
    nnor({'[e', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = bufnr})
    nnor({'[g', [[<Cmd>Lspsaga diagnostic_jump_next<CR>]], silent = true, buffer = bufnr})
    nnor({']e', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = bufnr})
    nnor({']g', [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], silent = true, buffer = bufnr})
    if has_wk then
      wk.register({
        ['[e'] = {[[<Cmd>Lspsaga diagnostic_jump_next<CR>]], 'Next diagnostic', buffer = bufnr},
        [']e'] = {[[<Cmd>Lspsaga diagnostic_jump_prev<CR>]], 'Previous diagnostic', buffer = bufnr},
      })
    end

    async:close()
  end))

  async:send()
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.window = capabilities.window or {}
capabilities.window.workDoneProgress = true
local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp_lsp then cmp_lsp.update_capabilities(capabilities) end

util.default_config = vim.tbl_extend('force', util.default_config,
                                     {capabilities = capabilities, on_attach = on_attach})

-- Apparently we need this set up early
require('nlspsettings').setup()
tablex.foreach({
  'bashls', 'cmake', 'denols', 'dotls', 'eslint', 'gopls', 'html', 'pyright', 'texlab', 'tsserver',
  'vimls', 'yamlls',
}, function(V) configs[V].setup({}) end)
configs.ccls.setup({
  init_options = {
    compilationDatabaseDirectory = 'build',
    index = {threads = 0},
    cache = {directory = '.ccls-cache'},
    clang = {resourceDir = '/usr/lib64/clang/13'},
    highlight = {lsRanges = true},
  },
})
configs.clangd.setup({init_options = {clangdFileStatus = true}})
configs.dockerls.setup({
  before_init = function(params) params.processId = vim.NIL end,
  cmd = lspcontainers.command('dockerls'),
  root_dir = util.root_pattern('.git', vim.fn.getcwd()),
})
configs.cssls.setup({filetypes = {'css', 'sass', 'scss', 'less'}})
-- configs.denols.setup({root_dir = require('user.cfg.lsp.utils').tsdetect('deno')})
configs.jsonls.setup({
  filetypes = {'json', 'jsonc'},
  settings = {json = {schemas = require('nlspsettings.jsonls').get_default_schemas()}},
})
configs.lemminx.setup({
  cmd = {vim.fn.exepath('lemminx')},
  settings = {xml = {server = {workDir = '~/.cache/lemminx'}}},
})
configs.sqlls.setup({cmd = {'sql-language-server', 'up', '--method', 'stdio'}})
configs.sumneko_lua.setup({cmd = {'lua-language-server'}})
-- configs.tsserver.setup({root_dir = require('user.cfg.lsp.utils').tsdetect('node')})

-- The giant language servers - diagnosticls & efm
-- more linters are @ https://github.com/iamcco/diagnostic-languageserver/wiki/Linters
-- configs.efm.setup({filetypes = {'eruby', 'make', 'zsh'}})
-- configs.diagnosticls.setup(require('user.cfg.lsp.diagnosticls'):setup())
-- require('rust-tools').setup({server = {capabilities = {window = {workDoneProgress = true}}}})
