" File: syntax/zshx.vim
" Author: Jaden Pleasants
" Description: From-scratch rewrite of zsh syntax
" Last Modified: November 15, 2019
if exists('b:current_syntax')|fini|en
let s:cpo_save = &cpoptions
set cpoptions&vim

" Temporary generated definitions {{{1
" `printf ${(k)builtins}`
syn keyword zshBuiltin unset zsocket rehash popd ulimit local jobs disable compfiles ztcp printf autoload noglob pushln zle readonly exit false times sysopen zcurses sched setopt getln builtin zdelattr let bg zstat which clone unhash pwd zparseopts logout disown zftp type source eval compdescribe comptags cap compctl r zselect zmodload pcre_match sysseek syswrite zregexparse history return exec compadd emulate chdir zsetattr ttyctl test comparguments pushd functions float zstyle print declare comptry alias shift zpty bindkey typeset true hash strftime setcap compset cd compvalues getopts compgroups export enable limit echotc echo wait dirs syserror unsetopt read integer bye echoti zgetattr compquote unfunction fc vared unalias kill compcall pcre_study where fg zlistattr zformat suspend pcre_compile unlimit break set continue command zcompile whence umask sysread getcap trap zsystem log private

" Syntax definitions {{{1
" Comments: {{{2
syn region zshComment start=/^\s*#/ end=/$/ fold oneline contains=@Spell,zshTodo
syn region zshComment start=/\s\+#/ end=/$/ fold oneline contains=@Spell,zshTodo

syn keyword zshTodo contained TODO FIXME XXX NOTE

" PreProcessors: {{{2
syn cluster zshPreProcs contains=zshPreProc,zshPreDefine,zshPreDesc
syn match zshPreProc /^\%1l#autoload.*$/
syn match zshPreProc /^\%1l#!.*$/
syn match zshPreDefine /^\%1l#compdef\s\+\S\+.*$/
syn match zshError /^\%1l#compdef\s*$/ " bad compdef
syn match zshPreDesc /^\%2l#description.\+$/

" Strings: {{{2
syn region zshString start=+"+ end=+"+ fold contains=zshLiteral
syn region zshString start=+'+ end=+'+ fold

syn match zshLiteral /\\./

" Numbers: {{{2

" Variables: {{{2


" Highlight settings {{{1
hi def link zshBuiltin Keyword
hi def link zshComment Comment
hi def link zshTodo Todo
hi def link zshPreDefine Define
hi def link zshPreProc PreProc
hi def link zshPreDesc Define
hi def link zshString String
hi def link zshLiteral SpecialChar
hi def link zshError Error

let b:current_syntax = 'zshx'
let &cpoptions = s:cpo_save
unlet s:cpo_save
" vim:ft=vim fdm=marker
