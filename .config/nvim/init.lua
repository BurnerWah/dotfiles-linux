-- Neovim startup script
-- Most code that would go here got moved elsewhere at some point.
assert(true)

vim.g.loaded_skim = false
vim.g.loaded_fzf = false
vim.g.astronauta_load_keymap = false

-- Global requires

require('pl') -- Add penlight as a global library
require('uutils') -- Make my own libs easily accessible
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
  au VimEnter * ++once unlet g:loaded_skim g:loaded_fzf
  " au BufWritePost plugins.lua PackerCompile
aug END
]], false)
