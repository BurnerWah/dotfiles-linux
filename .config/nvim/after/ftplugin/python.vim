" File: after/ftplugin/python.vim
" Author: Jaden Pleasants
" Description: Improvements to python editing
" Commands
com! -buffer -nargs=0 Autopep8 :ALEFix autopep8
com! -buffer -nargs=0 Black :ALEFix black
com! -buffer -nargs=0 Yapf :ALEFix yapf

" Maps
nmap <buffer> <silent> <leader>rr :Semshi rename<CR>
nmap <buffer> <silent> <Tab>      :Semshi goto name next<CR>
nmap <buffer> <silent> <S-Tab>    :Semshi goto name prev<CR>
nmap <buffer> <silent> <leader>c  :Semshi goto class next<CR>
nmap <buffer> <silent> <leader>C  :Semshi goto class prev<CR>
nmap <buffer> <silent> <leader>f  :Semshi goto function next<CR>
nmap <buffer> <silent> <leader>F  :Semshi goto function prev<CR>
nmap <buffer> <silent> <leader>ee :Semshi error<CR>
nmap <buffer> <silent> <leader>ge :Semshi goto error<CR>
nmap <buffer> <silent> gD <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
