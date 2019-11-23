if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

let &cpoptions = s:cpo_save
unlet s:cpo_save
