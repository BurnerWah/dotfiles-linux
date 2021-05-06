local M = {}

function M.setup()
  -- nvim_lsp support is now handled dynamically
  vim.g.vista_executive_for = {
    apiblueprint = 'markdown',
    markdown = 'toc',
    pandoc = 'markdown',
    rst = 'toc',
  }
  -- Consider checking for commands before enabling them.
  vim.g.vista_ctags_cmd = {go = 'gotags', rst = 'rst2ctags'}
  -- TODO: get vimwiki working
end

function M.config()
  local codicons = require('codicons')
  vim.g['vista#renderer#enable_icon'] = 1
  vim.g['vista#renderer#icons'] = {
    ['func'] = '',
    ['function'] = '',
    ['functions'] = '',
    ['var'] = codicons.get('symbol-variable'),
    ['variable'] = codicons.get('symbol-variable'),
    ['variables'] = codicons.get('symbol-variable'),
    ['const'] = codicons.get('symbol-constant'),
    ['constant'] = codicons.get('symbol-constant'),
    ['constructor'] = '',
    ['method'] = codicons.get('symbol-method'),
    ['enum'] = codicons.get('symbol-enum'),
    ['enummember'] = codicons.get('symbol-enum-member'),
    ['enumerator'] = codicons.get('symbol-enum'),
    ['module'] = '',
    ['modules'] = '',
    ['class'] = codicons.get('symbol-class'),
    ['struct'] = codicons.get('symbol-structure'),
    ['property'] = codicons.get('symbol-property'),
    ['interface'] = codicons.get('symbol-interface'),
    ['namespace'] = codicons.get('symbol-namespace'),
    ['field'] = codicons.get('symbol-field'),
    ['fields'] = codicons.get('symbol-field'),
  }
  vim.g.vista_echo_cursor_strategy = 'floating_win'
end

return M
