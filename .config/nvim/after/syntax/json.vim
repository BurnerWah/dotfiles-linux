" File: after/syntax/json.vim
" Author: Jaden Pleasants
" Description: Fixes to json.vim
" Last Modified: November 08, 2019

" Fix spelling issues
syn match jsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonString,@Spell
