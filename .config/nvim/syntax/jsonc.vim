" File: syntax/jsonc.vim
" Author: Jaden Pleasants
" Description: JSON with comments coc shut up they're fine and I really don't
" Last Modified: November 08, 2019

if exists('b:current_syntax')
  finish
endif

ru! syntax/json.vim

syn clear jsonCommentError

syn region jsoncComment start='\%(^\|\s\+\)//' end='$' contains=jsonTodo,@Spell fold oneline
syn region jsoncComment start='/\*' end='\*/' contains=jsonTodo,@Spell fold

syn keyword jsoncTodo contained TODO FIXME XXX NOTE

hi def link jsoncComment Comment
hi def link jsoncTodo Todo

let b:current_syntax = 'jsonc'
