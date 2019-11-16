" File: ftplugin/zshx.vim
" Author: Jaden Pleasants
" Description: ftplugin for ZshX
" Last Modified: November 15, 2019
if exists('b:did_ftplugin')|fini|en
let b:did_ftplugin = 1
let s:cpo_save = &cpoptions
set cpoptions&vim

setl comments=:# commentstring=#\ %s

let &cpoptions = s:cpo_save
unlet s:cpo_save
