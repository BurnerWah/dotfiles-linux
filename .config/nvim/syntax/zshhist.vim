" Vim syntax file (minified)
" Language: Zsh history
" Author: Jaden Pleasants
if exists('b:current_syntax')|fini|en
let s:cpo_save=&cpo
se cpo&vim
sy include @Zsh syntax/zsh.vim
unl b:current_syntax
sy region zshhistCmd start='.' end='$' contains=@Zsh contained keepend transparent
sy match zshhistPrefix /\v^\: \d+\:\d+;/ nextgroup=zshhistCmd contains=@NoSpell skipwhite
hi def link zshhistPrefix Comment
let b:current_syntax='zshhist'
let &cpo=s:cpo_save
unl s:cpo_save
