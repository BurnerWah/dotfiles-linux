" File: ublock.vim
" Author: Jaden Pleasants
" Description: Syntax highlighting for uBlock origin & AdBlock filters
" Last Modified: November 07, 2019

" Pre-work {{{1
if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" Syntax settings {{{1
" Comments {{{2
syn region ublockComment oneline fold start='^!' end='$' contains=ublockTodo,ublockInfo,@ublockPreProcs,@Spell

syn keyword ublockTodo contained TODO FIXME XXX NOTE
syn match ublockInfo contained /^!\s\+\zs\%(Title\|Expires\|Description\|Homepage\|Licence\|Redirect\|Version\):/

" Preprocessors {{{2
syn cluster ublockPreProcs contains=ublockPreProc,ublockPreCondit,ublockInclude
syn region ublockPreProc contained oneline start='^!#' end='$' contains=@NoSpell
syn region ublockPreCondit contained oneline start='^!#\%(if\|endif\)' end='$' contains=@NoSpell
syn region ublockInclude contained oneline start='^!#include' end='$' contains=@NoSpell

" Static network filters {{{2
syn region ublockStaticBlock oneline start='^||.\+' end='$' contains=ublockStaticOpts
syn region ublockStaticAllow oneline start='^@@||.\+' end='$' contains=ublockStaticOpts
syn region ublockStaticOpts contained start='\^\?\$' end='$' contains=ublockStaticOpt
syn keyword ublockStaticOpt contained script image stylesheet object xmlhttprequest
syn keyword ublockStaticOpt contained
      \ badfilter important subdocument ping websocket
      \ webrtc document popup font media other match-case
" NOTE: Only for exception rules
syn keyword ublockStaticOpt contained elemhide generichide genericblock
" TODO: The following options take arguments
syn keyword ublockStaticOpt contained domain sitekey csp rewrite
" NOTE: uBlock Origin Specific
syn keyword ublockStaticOpt contained
      \ 1p 3p all badfilter css document empty first-party frame important
      \ inline-script third-party inline-font mp4 popunder xhr
" TODO: The following options take arguments
syn keyword ublockStaticOpt contained redirect redirect-rule

" Highlight settings {{{1
hi def link ublockComment Comment
hi def link ublockTodo Todo
hi def link ublockInfo PreProc
hi def link ublockPreProc PreProc
hi def link ublockPreCondit PreCondit
hi def link ublockInclude Include
hi def link ublockStaticBlock Identifier
hi def link ublockStaticOpts Operator
hi def link ublockStaticOpt Keyword

" Cleanup {{{1
let b:current_syntax = 'ublock'
let &cpoptions = s:cpo_save
unlet s:cpo_save
" vim: ft=vim fdm=marker
