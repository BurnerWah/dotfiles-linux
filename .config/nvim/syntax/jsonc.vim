" File: syntax/jsonc.vim
" Author: Jaden Pleasants
" Description: JSON with comments coc shut up they're fine and I really don't
" Last Modified: November 08, 2019
"
" This is designed to either be injected to OR to extend the JSON syntax.
" Setting the filetype to jsonc should work, and so should b:is_jsonc.

if !exists('b:is_jsonc')
  if exists('b:current_syntax')
    finish
  endif

  ru! syntax/json.vim
endif

syn clear jsonCommentError

syn region jsoncComment start='\%(^\|\s\+\)//' end='$' contains=jsonTodo,@Spell fold oneline
syn region jsoncComment start='/\*' end='\*/' contains=jsonTodo,@Spell fold

syn keyword jsoncTodo contained TODO FIXME XXX NOTE

hi def link jsoncComment Comment
hi def link jsoncTodo Todo

if !exists('b:is_jsonc')
  let b:current_syntax = 'jsonc'
endif
