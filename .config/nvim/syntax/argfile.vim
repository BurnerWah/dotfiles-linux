" Simple syntax for config files that contain program arguments
if exists('b:current_syntax')
  finish
end

let s:cpo_save = &cpoptions
set cpoptions&vim

" Not all of these are garunteed to be valid
syn match argComment /^#.\+/
syn match argFlag /^\zs--\?[0-9A-Za-z-]\+/
syn region argString keepend start=+"+ skip=+\\"+ end=+"+
syn region argString keepend start=+'+ skip=+\\'+ end=+'+
syn match argSpecial /[*]/
syn match argNumber /\<\d\+\>/

hi def link argComment Comment
hi def link argFlag Keyword
hi def link argString String
hi def link argSpecial Special
hi def link argNumber Number

let b:current_syntax = 'argfile'

let &cpoptions = s:cpo_save
unlet s:cpo_save
