" Commands
com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')

" Maps
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
