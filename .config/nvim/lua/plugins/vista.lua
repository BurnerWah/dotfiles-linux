vim.g['vista#renderer#enable_icon'] = 1
vim.g['vista#renderer#icons'] = {
  ['func'] = '',
  ['function'] = '',
  ['functions'] = '',
  ['var'] = '',
  ['variable'] = '',
  ['variables'] = '',
  ['const'] = '',
  ['constant'] = '',
  ['constructor'] = '',
  ['method'] = 'ƒ',
  ['enum'] = '了',
  ['enummember'] = '',
  ['enumerator'] = '了',
  ['module'] = '',
  ['modules'] = '',
  ['class'] = '',
  ['struct'] = '',
  ['property'] = '',
  ['interface'] = 'ﰮ',
}
vim.g.vista_echo_cursor_strategy = 'floating_win'
-- nvim_lsp support is now handled dynamically
vim.g.vista_executive_for = {
  apiblueprint = 'markdown',
  markdown = 'toc',
  pandoc = 'markdown',
  rst = 'toc',
}
-- Consider checking for commands before enabling them.
vim.g.vista_ctags_cmd = {go = 'gotags', rst = 'rst2ctags'}
