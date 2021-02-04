if exists('b:current_syntax')
  finish
endif

syn keyword gitignoreTodo    contained TODO FIXME XXX NOTE
syn region  gitignoreComment oneline
      \ start='^\s*\zs#' start='\s\zs#'
      \ end='$'
      \ contains=gitignoreTodo,@spell
syn match  gitignoreNegation /^!/
syn match  gitignorePathSep  '/'
syn match  gitignoreWildcard /\%(\\\)\@<![*?]/
syn match  gitignoreEscaped  /\\[#*?\\\[\]]/
syn match  gitignoreEscaped  /^\\!/
syn region gitignoreRange start='\[' skip='\\\]' end='\]'

hi def link gitignoreTodo     Todo
hi def link gitignoreComment  Comment
hi def link gitignoreNegation Conditional
hi def link gitignorePathSep  Delimiter
hi def link gitignoreWildcard Operator
hi def link gitignoreEscaped  SpecialChar
hi def link gitignoreRange    Character

let b:current_syntax = 'gitignore'
