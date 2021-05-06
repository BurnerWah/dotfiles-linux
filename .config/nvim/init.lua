-- Neovim startup script
-- Most code that would go here got moved elsewhere at some point.
assert(true, 'formatter no-op')

-- Global requires

-- require('profiler')
require('pl.text').format_operator() -- This is too useful to live without sometimes
require('user.options') -- Set my vim options
require('plugins') -- Load my plugins
require('astronauta.keymap') -- Add astronauta keymaps early so they can be utilized freely
require('user.keymaps') -- Add my own keymaps

-- Augroups (don't support lua)
vim.api.nvim_exec([[
" We just need this group initialized
aug user_ftplugin
aug END
" Init augroup
aug init
  au!
  au BufEnter * if (winnr('$') == 1 && &filetype =~# '\%(vista\|vista_kind\|minimap\|tsplayground\)') | quit | endif
  au FileType group,man,shada setl nospell
  au FileType help setl signcolumn=no
  au VimEnter * ++once silent delcommand GBrowse
  " au BufWritePost plugins.lua PackerCompile
  au TextYankPost * lua require('vim.highlight').on_yank {higroup = 'Search', timeout = 200}
aug END
]], false)
