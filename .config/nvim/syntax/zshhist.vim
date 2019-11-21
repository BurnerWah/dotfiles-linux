" Vim syntax file
" Language: Zsh history
" Author: Jaden Pleasants
if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

syn include @Zsh syntax/zsh.vim
unlet b:current_syntax

syn region zshhistCmd start='.' end='$' contains=@Zsh contained keepend transparent
syn match zshhistPrefix /\v^\: \d+\:\d+;/ nextgroup=zshhistCmd contains=@NoSpell skipwhite

hi def link zshhistPrefix Comment

let b:current_syntax = 'zshhist'
let &cpoptions = s:cpo_save
unlet s:cpo_save
