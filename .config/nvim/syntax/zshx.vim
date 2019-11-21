" File: syntax/zshx.vim
" Author: Jaden Pleasants
" Description: From-scratch rewrite of zsh syntax
" Last Modified: November 15, 2019
if exists('b:current_syntax')|fini|en
let s:cpo_save = &cpoptions
set cpoptions&vim

" Temporary generated definitions {{{1
" `printf ${(k)builtins}`
syn keyword zshxBuiltin unset zsocket rehash popd ulimit local jobs disable compfiles ztcp printf autoload noglob pushln zle readonly exit false times sysopen zcurses sched setopt getln builtin zdelattr let bg zstat which clone unhash pwd zparseopts logout disown zftp type source eval compdescribe comptags cap compctl r zselect zmodload pcre_match sysseek syswrite zregexparse history return exec compadd emulate chdir zsetattr ttyctl test comparguments pushd functions float zstyle print declare comptry alias shift zpty bindkey typeset true hash strftime setcap compset cd compvalues getopts compgroups export enable limit echotc echo wait dirs syserror unsetopt read integer bye echoti zgetattr compquote unfunction fc vared unalias kill compcall pcre_study where fg zlistattr zformat suspend pcre_compile unlimit break set continue command zcompile whence umask sysread getcap trap zsystem log private

" Syntax definitions {{{1
" Comments: {{{2
syn region zshxComment start=/^\s*#/ end=/$/ fold oneline contains=@Spell,zshTodo
syn region zshxComment start=/\s\+#/ end=/$/ fold oneline contains=@Spell,zshTodo

syn keyword zshxTodo contained TODO FIXME XXX NOTE

" PreProcessors: {{{2
syn cluster zshxPreProcs contains=zshPreProc,zshPreDefine,zshPreDesc
syn match zshxPreProc /^\%1l#autoload.*$/
syn match zshxPreProc /^\%1l#!.*$/
syn match zshxPreDefine /^\%1l#compdef\s\+\S\+.*$/
syn match zshxError /^\%1l#compdef\s*$/ " bad compdef
syn match zshxPreDesc /^\%2l#description.\+$/

" Strings: {{{2
syn region zshxString start=+"+ end=+"+ fold contains=zshLiteral
syn region zshxString start=+'+ end=+'+ fold

syn match zshLiteral /\\./

" Operators: {{{2
syn match zshxOperator /||\|&&\|;\|==/

" Numbers: {{{2
syn match zshxNumber /[+-]\?\<\d\+\>/
syn match zshxNumber /[+-]\?\<0x\x\+\>/
syn match zshxNumber /[+-]\?\<0\o\+\>/
syn match zshxNumber /[+-]\?\d\+\.\d\+\>/

" Variables: {{{2
syn cluster zshxVars contains=zshxReference,zshxUserDir
syn match zshxReference /\$\<\h\w*\>/
syn match zshxUserDir /\~\<\h\w*\>/

" Math: {{{2
syn cluster zshxMathGroup contains=zshxMathOperator,zshxNumber
syn region zshxMath matchgroup=zshxMathDelim start=+\$\?((+ end=+))+ contains=@zshxMathGroup
syn match zshxMathOperator '\%(<<\|>>\|&&\|||\|^^\|\*\*\)=\?' contained
syn match zshxMathOperator '[+\-*/%&^|<>=!]=\?' contained
syn match zshxMathOperator '?\|:\|~\|++\|--' contained

" Highlight settings {{{1
hi def link zshxBuiltin Keyword
hi def link zshxComment Comment
hi def link zshxTodo Todo
hi def link zshxPreDefine Define
hi def link zshxPreProc PreProc
hi def link zshxPreDesc Define
hi def link zshxString String
hi def link zshxLiteral SpecialChar
hi def link zshxOperator Operator
hi def link zshxNumber Number
hi def link zshxReference Identifier
hi def link zshxUserDir zshxReference
hi def link zshxMathDelim zshxOperator
hi def link zshxMathOperator zshxOperator
hi def link zshxError Error

let b:current_syntax = 'zshx'
let &cpoptions = s:cpo_save
unlet s:cpo_save
" vim:ft=vim fdm=marker
