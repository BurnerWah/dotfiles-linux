" File: environment.vim
" Author: Jaden Pleasants
" Description: Syntax for systemd environment files
" Last Modified: October 01, 2019

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

syn region systemdEnvComment oneline fold start='^#' end='$' contains=@spell,systemdEnvTodo
syn keyword systemdEnvTodo contained TODO FIXME XXX NOTE

syn match systemdEnvVariable /\v^<\h\w*/

hi def link systemdEnvComment Comment
hi def link systemdEnvTodo Todo
hi def link systemdEnvVariable Identifier

let b:current_syntax = 'environment'

let &cpoptions = s:cpo_save
unlet s:cpo_save
