" File: after/syntax/vim.vim
" Author: Jaden Pleasants
" Description: Extensions to vim syntax
" Last Modified: October 10, 2019
" vim:ft=vim fdm=marker

scriptenc 'utf-8'

syn cluster vimRegGroups contains=vimRegGroup,vimRegEither,vimRegCondit
syn cluster vimRegAnchors contains=vimRegStr,vimRegMatch,vimRegWord,vimRegWeird
syn cluster vimRegMeta contains=vimRegLiteral,vimRegNonAscii,vimRegReference,vimRegAny
syn cluster vimRegQuant contains=vimRegQuantity,vimReg0Or1,vimReg1OrMore,vimRegGreedy
syn cluster vimRegChars contains=vimRegChar,vimRegCharClass
syn cluster vimRegCluster contains=vimRegFlag,vimRegErr,vimRegNumber,@vimRegAnchors,@vimRegChars,@vimRegGroups,@vimRegMeta,@vimRegQuant

syn cluster vimOperGroup add=vimVar
syn cluster vimStringGroup    add=@vimRegCluster
syn cluster vimSubstList      add=@vimRegCluster
syn cluster vimSynRegGroup    add=@vimRegCluster
syn cluster vimSynRegPatGroup add=@vimRegCluster


" Syntax definitions {{{1
" Functions {{{2
syn match vimRichFunc transparent 'get(\s*\zs[bwtglsav]:\s*,\s*[\'"]\h\w*\%(\.\h\w*\)*[\'"]\ze' contains=vimRichFuncGetConceal,vimRichFuncGetHL
syn match vimRichFuncGetConceal contained '[bwtglsav]:\zs\s*,\s*\ze[\'"]' conceal transparent
syn match vimRichFuncGetHL contained '[bwtglsav]:'
syn match vimRichFuncGetHL contained '\h\w*\%(\.\h\w*\)*'

hi def link vimRichFungGetHL vimVar

" Syntax: conceal {{{2
" This was outright missing from the default syntax. Why I don't know.
syn match vimSynType contained 'conceal' skipwhite nextgroup=FixVimSynType
syn keyword vimSynConcealOpt contained on off

" Variables: Constants {{{2
" A lot of Vim variables are constants.
" Stupidly enough, we can get a list of Vim vars by listing the keys in v:.
exe 'syn match vimConstant contained /\<v:\%('.join(keys(v:), '\|').'\)/ containedin=vimVar'

" Autocmd {{{2
syn match vimAutoCmdSfxList contained '\S*' nextgroup=vimCommand,vimAutoCmdExtend skipwhite
syn match vimAutoCmdExtend contained '^\s*\\|.*$' contains=vimContinue

" Maps {{{2
"syn match vimMapRhs contained '.*\ze\s*[^|]$' contains=vimNotation,vimCtrlChar skipnl nextgroup=vimMapRhsExtend
syn match vimMapRhs contained '.*\%(\s*|$\)\@!' contains=vimNotation,vimCtrlChar skipnl nextgroup=vimMapRhsExtend
syn match vimMapRhs contained '.*\ze\s\+|$' contains=vimNotation,vimCtrlChar
syn clear vimMapRhsExtend
syn match vimMapRhsExtend contained '^\s*\\[^|].*$' contains=vimContinue

" Operators: equivalence {{{2
syn match vimOper '==[#?]\?' conceal cchar== skipwhite nextgroup=vimString,vimSpecFile
syn match vimOper '!=[#?]\?' conceal cchar=≠ skipwhite nextgroup=vimString,vimSpecFile
" Operators: greater {{{2
syn match vimOper '>[#?]' conceal cchar=> skipwhite nextgroup=vimString,vimSpecFile
syn match vimOper '>=[#?]\?' conceal cchar=≥ skipwhite nextgroup=vimString,vimSpecFile
" Operators: less {{{2
syn match vimOper '<[#?]' conceal cchar=< skipwhite nextgroup=vimString,vimSpecFile
syn match vimOper '<=[#?]\?' conceal cchar=≤ skipwhite nextgroup=vimString,vimSpecFile
" Operators: regex {{{2
syn match vimOper '=\~[#?]\?' conceal cchar=≃ skipwhite nextgroup=vimString,vimSpecFile
syn match vimOper '!\~[#?]\?' conceal cchar=≄ skipwhite nextgroup=vimString,vimSpecFile
" Operators: congruency {{{2
syn match vimOper '\<is[#?]\?\>' conceal cchar=≡ skipwhite nextgroup=vimString,vimSpecFile
syn match vimOper '\<isnot[#?]\?\>' conceal cchar=≢ skipwhite nextgroup=vimString,vimSpecFile

" Regexp: hidden {{{2
syn match vimRegHide    contained transparent conceal '\\'
syn match vimRegHideStr contained transparent conceal '\\_'
syn match vimRegHideGrp contained transparent conceal '\\%\?'

" Regexp: Special Characters {{{2
" NOTE: Literals fail to match without the lookbehind :(
" NOTE: This is intentionally inaccurate.
syn match vimRegLiteral   contained '\%(\%(\\\\\)*\)\@<=\\\W'
" invalid literals: \c[1-9a-fhik-pr-z_+=?_@&<>%(|){]
"   + substitution: \c[[:digit:]a-fhik-pr-z_+=?_@&<>%(|){] : +0
"       + reserved: \c[[:alnum:]_+=?_@&<>%(|){]         : +gjq
syn match vimRegAny       contained '\%(\\\\\)*\zs\%[\\_]\.'
syn match vimRegNonAscii  contained '\%(\\\\\)*\zs\\%d\d\+'
syn match vimRegNonAscii  contained '\%(\\\\\)*\zs\\%o\o\{2,4}'
syn match vimRegNonAscii  contained '\%(\\\\\)*\zs\\%x\x\{1,2}'
syn match vimRegNonAscii  contained '\%(\\\\\)*\zs\\%u\x\{1,4}'
syn match vimRegNonAscii  contained '\%(\\\\\)*\zs\\%U\x\{1,8}'
syn match vimRegNonAscii  contained '\%(\\\\\)*\zs\\%C'
syn match vimRegReference contained '\%(\\\\\)*\zs\\\d'
" NOTE: The incorrect \0 match is to improve performance.

" Regexp: Weird anchors {{{2
" NOTE: This has conflicts with and should be clobbered by Flags.
syn match vimRegWeird contained '\%(\\\\\)*\zs\\%\%([\^$V#]\|[<>]\?\'m\)'
syn match vimRegWeird contained '\%(\\\\\)*\zs\\%[<>]\?\d+[lcv]'

" Regexp: flags {{{2
syn match vimRegFlag contained '\%(\\\\\)*\zs\\[mMvVcCZ]'
syn match vimRegFlag contained '\%(\\\\\)*\zs\\%#=[012]'

" Regexp: Anchors {{{2
syn match vimRegStr contained '\%(^|[\'"/]\)\zs\^'
syn match vimRegStr contained '\$\_$'
syn match vimRegStr contained '\%(\\\\\)*\zs\\_[\^$]' contains=vimRegHideStr
syn match vimRegMatch  contained '\%(\\\\\)*\zs\\z[se]'
syn match vimRegWord   contained '\%(\\\\\)*\zs\\[<>]' contains=vimRegHide

" Regexp: Quantifiers {{{2
syn match vimRegQuantity contained '\%(\\\\\)*\zs\\{-\?\d*\%(,\d*\)\?}' contains=vimRegUnsafeNumber,vimRegHide
syn match vimReg1OrMore contained '\%(\\\\\)*\zs\\+' contains=vimRegHide
syn match vimReg0Or1    contained '\%(\\\\\)*\zs\\?' contains=vimRegHide
syn match vimReg0Or1    contained '\%(\\\\\)*\zs\\=' conceal cchar=?
syn match vimRegGreedy  contained '\%(\\\\\)*\zs\*'
syn match vimRegGreedy  contained '\%(\\\\\)*\zs\\{}' conceal cchar=*
" NOTE: People who use {} deserve the death

" Regexp: Groups {{{2
syn match vimRegGroup contained '\%(\\\\\)*\zs\\%\?(' contains=vimRegHideGrp
syn match vimRegGroup contained '\%(\\\\\)*\zs\\)' contains=vimRegHide
syn match vimRegEither contained '\%(\\\\\)*\zs\\|' contains=vimRegHide

" Regexp: Conditions {{{2
syn match vimRegErr contained '\%(\\\\\)*\zs\\@\d*<\?\ze[\'"/]\?'
" NOTE: The error is inaccurate so the correct syntax replaces it.
syn match vimRegCondit contained '\%(\\\\\)*\zs\\@\%(\%(\d*<\)\?[=!]\|>\)'
syn match vimRegCondit contained '\%(\\\\\)*\zs\\&'
" NOTE: \& = \@!

" Regexp: Characters {{{2
syn match vimRegChar contained '\%(\\\\\)*\zs\\[etrbn]'
syn match vimRegCharClass contained '\%(\\\\\)*\zs\c\\_\?[ikfpsdxowhalu]'

" Regexp: Numbers {{{2
syn match vimRegNumber contained '\%(\\\\\)*\zs\d\+'
syn match vimRegUnsafeNumber contained '\d+'

" Regexp: Errors {{{2
" These errors will cause the regex engine to fail.
syn match vimRegErr contained '\%(\\\\\)*\zs\\%#=\%(\ze[\'"/]\|[^012]\)'
syn match vimRegErr contained '\%(\\\\\)*\zs\\z\%(\ze[\'"/]\|[^se[:digit:](]\)'
syn match vimRegErr contained '\%(\\\\\)*\zs\\_\%(\ze[\'"/]\|\c[^ikfpsdxowhalu\^$.\[]\)'

" These are just bad syntax
syn match vimRegErr contained '\%(\\\\\)*\zs\\[ETRBNgGjJqQ]' " reserved escapes
syn match vimRegErr contained '\%(\\\\\)*\zs\\{-,}' " syntax error, not too problematic


" Highlight settings {{{1
hi def link vimRegFlag PreCondit

hi def link vimRegWeird Operator
hi def link vimRegStr Operator
hi def link vimRegWord Operator
hi def link vimRegMatch Operator

hi def link vimRegLiteral SpecialChar
hi def link vimRegAny SpecialChar
hi def link vimRegNonAscii Special
hi def link vimRegReference Identifier

hi def link vimRegQuantity Delimiter
hi def link vimReg0Or1 Number
hi def link vimReg1OrMore Number
hi def link vimRegGreedy Number

hi def link vimRegGroup Delimiter
hi def link vimRegEither Delimiter
hi def link vimRegCondit Conditional

hi def link vimRegChar SpecialChar
hi def link vimRegCharClass Structure

hi def link vimRegNumber Number
hi def link vimRegUnsafeNumber Number

hi def link vimSubstSubstr Identifier

hi def link vimRegNum Number
hi def link vimRegErr Error

hi def link vimSynConcealOpt vimSynType
hi def link vimConstant Constant
