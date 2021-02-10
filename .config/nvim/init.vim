" File: init.vim
" Author: Jaden Pleasants
" Description: neovim configuration
" Last Modified: September 16, 2019

" Notes
" This configuration is specifically targeting neovim. It doesn't have a check
" to see if that's what you're running at the start, but it will probably
" throw a lot of errors if for some reason you decide to load this in regular
" Vim.
"
" Also, since Vim allows you to use shortened versions of keywords, I'm
" sticking to the shortest version that makes sense.

" Core settings
scriptenc 'utf-8'
syn enable " Enable syntax highlighting.

let g:loaded_skim = 0
let g:loaded_fzf = 0
let g:netrw_nogx = 1
lua require('user.options')
lua require('plugins')

" We just need this group initialized
aug user_ftplugin
aug END
" Init augroup
aug init
  au!
  au CompleteDone * if pumvisible() == 0 | pclose | endif
  au BufEnter * if (winnr('$') == 1 && &filetype =~# '\%(vista\|vista_kind\|minimap\|tsplayground\)') | quit | endif
  au FileType desktop setl comments=:# commentstring=#\ %s
  au FileType group,man,shada setl nospell
  au FileType help setl signcolumn=no
  au FileType terminfo let &l:makeprg = executable('tic') ? 'tic' : &makeprg
  au VimEnter * ++once lua require('user.keymaps')
  " Delay forces this to load after plugins
  au VimEnter * ++once unlet g:loaded_skim g:loaded_fzf
aug END
" vim:ft=vim fenc=utf-8
