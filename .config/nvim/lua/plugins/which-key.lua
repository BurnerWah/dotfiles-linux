local wk = require('which-key')
wk.setup({
  operators = {zF = 'Create fold', Ys = 'Create surround', YS = 'Create surround', ga = 'Align'},
})
wk.register({
  ['<leader>'] = {
    ['1'] = 'which_key_ignore',
    ['2'] = 'which_key_ignore',
    ['3'] = 'which_key_ignore',
    ['4'] = 'which_key_ignore',
    ['5'] = 'which_key_ignore',
    ['6'] = 'which_key_ignore',
    ['7'] = 'which_key_ignore',
    ['8'] = 'which_key_ignore',
    ['9'] = 'which_key_ignore',
    ['0'] = 'which_key_ignore',
  },
})
wk.register({f = {name = 'find', f = {[[<Cmd>Telescope find_files<CR>]], 'Find File'}}},
            {prefix = [[<leader>]]})
wk.register({w = {name = 'VimWiki', w = {'Open index'}, t = {'Open index in new tab'}}},
            {prefix = '<leader>'})
wk.register({
  ['<leader>gm'] = {[[<Plug>(git-messenger)]], 'Show git commit info'},
  ['<leader>gy'] = {'Get the URL for a line of code'},
})
wk.register({
  ['[c'] = {[[&diff ? '[c' : '<cmd>lua require"gitsigns".prev_hunk()<CR>']], 'Previous Hunk'},
  [']c'] = {[[&diff ? ']c' : '<cmd>lua require"gitsigns".next_hunk()<CR>']], 'Next Hunk'},
  ['[*'] = {'Previous comment'},
  [']*'] = {'Next comment'},
  ['[/'] = {'Previous comment'},
  [']/'] = {'Next comment'},
})
wk.register({
  z = {
    -- buffer foldmethod must be marker or manual
    d = {'zd<Plug>(ScrollViewRefresh)', 'Delete one fold at cursor'},
    D = {'zD<Plug>(ScrollViewRefresh)', 'Delete all folds at cursor'},
  },
})
require('plugins.which-key.surround')
