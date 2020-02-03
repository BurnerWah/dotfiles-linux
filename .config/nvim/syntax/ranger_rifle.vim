" Extended filetype for ranger's rifle config file
if exists('b:current_syntax')
  finish
endif
if !exists('b:main_syntax')
  let b:main_syntax = 'ranger_rifle'
  syn clear
endif

runtime! syntax/cfg.vim
unlet b:current_syntax

syn case match

" Fixes made to cfg syntax
syn clear CfgComment
syn match CfgComment /#.*/ contains=@Spell

" Include sh for command highlighting
let b:is_bash = 1
syn include @Sh syntax/sh.vim

" Clusters
syn cluster RifleKeywords contains=RifleCondition,RifleAction
syn cluster RifleNext contains=RifleDelim,RifleShell

" Groups
syn match RifleNegate /!/ nextgroup=@RifleKeywords
syn match RifleDelim /,/ nextgroup=@RifleKeywords,RifleNegate skipwhite


syn keyword RifleCondition skipwhite match ext mime name path nextgroup=RiflePattern
syn keyword RifleCondition skipwhite env nextgroup=RifleEnv
syn keyword RifleCondition skipwhite has nextgroup=RifleCommand
syn keyword RifleCondition skipwhite number nextgroup=RifleNumber
syn keyword RifleCondition skipwhite file directory terminal X else nextgroup=@RifleNext

syn keyword RifleAction skipwhite flag nextgroup=RifleFlag
syn keyword RifleAction skipwhite label nextgroup=RifleLabel

syn match RiflePattern contained skipwhite /[^,=]\+/ contains=RiflePatOper nextgroup=@RifleNext
syn match RifleLabel contained skipwhite /[^,=]\+/ nextgroup=@RifleNext
syn match RifleCommand contained skipwhite /[0-9A-Za-z_-]\+/ nextgroup=@RifleNext
syn match RifleNumber contained skipwhite /\d\+/ nextgroup=@RifleNext

syn keyword RifleFlag contained skipwhite f r t nextgroup=@RifleNext

syn match RiflePatOper contained /[?|\[\]$^]/

syn region RifleShell contained matchgroup=RifleOperator start=+=+ end=+$+ contains=@Sh

hi def link RifleCondition Conditional
hi def link RifleAction Function
hi def link RiflePattern String
hi def link RIflePatOper Operator
hi def link RifleLabel String
hi def link RifleNegate Operator
" hi def link RifleDelim Operator
hi def link RifleOperator Operator
hi def link RifleCommand String
hi def link RifleNumber Number
hi def link RifleFlag Type

let b:current_syntax = 'ranger_rifle'
