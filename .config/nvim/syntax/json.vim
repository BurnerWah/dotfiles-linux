" File: after/syntax/json.vim
" Author: Jaden Pleasants
" Description: Fixes to json.vim
" Last Modified: November 08, 2019

" Fix spelling issues
syn match  jsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonString,@Spell

if exists('b:is_jsonc')
  syn clear jsonCommentError

  syn region jsonComment start='\%(^\|\s\+\)//' end='$' contains=jsonTodo,@Spell fold oneline
  syn region jsonComment start='/\*' end='\*/' contains=jsonTodo,@Spell fold

  syn keyword jsonTodo contained TODO FIXME XXX NOTE

  hi def link jsonComment Comment
  hi def link jsonTodo Todo
endif
