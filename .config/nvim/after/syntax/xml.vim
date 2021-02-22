" File: after/syntax/xml.vim
" Author: Jaden Pleasants
" Description: Conceals stuff in xml files
" Last Modified: October 08, 2019

scriptenc utf-8
syn conceal on

syn match xmlEntHide transparent contained containedin=xmlEntity '&quot;' cchar="
syn match xmlEntHide transparent contained containedin=xmlEntity '&amp;' cchar=&
syn match xmlEntHide transparent contained containedin=xmlEntity '&apos;' cchar='
syn match xmlEntHide transparent contained containedin=xmlEntity '&lt;' cchar=<
syn match xmlEntHide transparent contained containedin=xmlEntity '&gt;' cchar=>

syn conceal off
