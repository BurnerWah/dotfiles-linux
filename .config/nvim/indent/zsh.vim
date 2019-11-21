" Vim indent file
" Language:            Shell Script
" Maintainer:          Christian Brabandt <cb@256bit.org>
" Original Author:     Nikolai Weibull <now@bitwi.se>
" Previous Maintainer: Peter Aronoff <telemachus@arpinum.org>
" Latest Revision:     2019-07-26
" License:             Vim (see :h license)
" Repository:          https://github.com/chrisbra/vim-sh-indent
" Changelog:
"          20190726  - Correctly skip if keywords in syntax comments
"                      (issue #17)
"          20190603  - Do not indent in zsh filetypes with an `if` in comments
"          20190428  - De-indent fi correctly when typing with
"                      https://github.com/chrisbra/vim-sh-indent/issues/15
"          20190325  - Indent fi; correctly
"                      https://github.com/chrisbra/vim-sh-indent/issues/14
"          20190319  - Indent arrays (only zsh and bash)
"                      https://github.com/chrisbra/vim-sh-indent/issues/13
"          20190316  - Make use of searchpairpos for nested if sections
"                      fixes https://github.com/chrisbra/vim-sh-indent/issues/11
"          20190201  - Better check for closing if sections
"          20180724  - make check for zsh syntax more rigid (needs word-boundaries)
"          20180326  - better support for line continuation
"          20180325  - better detection of function definitions
"          20180127  - better support for zsh complex commands
"          20170808: - better indent of line continuation
"          20170502: - get rid of buffer-shiftwidth function
"          20160912: - preserve indentation of here-doc blocks
"          20160627: - detect heredocs correctly
"          20160213: - detect function definition correctly
"          20160202: - use shiftwidth() function
"          20151215: - set b:undo_indent variable
"          20150728: - add foreach detection for zsh

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

" setlocal indentexpr=GetShIndent()
" setlocal indentkeys+=0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,0=end,),0=;;,0=;&
" setlocal indentkeys+=0=fin,0=fil,0=fip,0=fir,0=fix
" setlocal indentkeys-=:,0#
" setlocal nosmartindent

" let b:undo_indent = 'setlocal indentexpr< indentkeys< smartindent<'

let s:cpo_save = &cpoptions
set cpoptions&vim



let &cpoptions = s:cpo_save
unlet s:cpo_save
