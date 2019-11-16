" File: after/ftplugin/python.vim
" Author: Jaden Pleasants
" Description: Improvements to python editing

nmap <buffer> <silent> <leader>rr :Semshi rename<CR>
nmap <buffer> <silent> <Tab>      :Semshi goto name next<CR>
nmap <buffer> <silent> <S-Tab>    :Semshi goto name prev<CR>
nmap <buffer> <silent> <leader>c  :Semshi goto class next<CR>
nmap <buffer> <silent> <leader>C  :Semshi goto class prev<CR>
nmap <buffer> <silent> <leader>f  :Semshi goto function next<CR>
nmap <buffer> <silent> <leader>F  :Semshi goto function prev<CR>
nmap <buffer> <silent> <leader>ee :Semshi error<CR>
nmap <buffer> <silent> <leader>ge :Semshi goto error<CR>
