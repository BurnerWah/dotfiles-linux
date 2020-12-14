" File: after/ftplugin/python.vim
" Author: Jaden Pleasants
" Description: Improvements to python editing

" Use tree-sitter handle folding
setl foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

if exists(':ALEFix')
  if executable(get(g:, 'ale_python_autopep8_executable', 'autopep8'))
    com! -buffer -nargs=0 Autopep8 :ALEFix autopep8
  endif
  if executable(get(g:, 'ale_python_black_executable', 'black'))
    com! -buffer -nargs=0 Black :ALEFix black
  endif
  if executable(get(g:, 'ale_python_yapf_executable', 'yapf'))
    com! -buffer -nargs=0 Yapf :ALEFix yapf
  endif
endif

if exists(':Semshi')
  nmap <buffer> <silent> <leader>rr :Semshi rename<CR>
  nmap <buffer> <silent> <Tab>      :Semshi goto name next<CR>
  nmap <buffer> <silent> <S-Tab>    :Semshi goto name prev<CR>
  nmap <buffer> <silent> <leader>c  :Semshi goto class next<CR>
  nmap <buffer> <silent> <leader>C  :Semshi goto class prev<CR>
  nmap <buffer> <silent> <leader>f  :Semshi goto function next<CR>
  nmap <buffer> <silent> <leader>F  :Semshi goto function prev<CR>
  nmap <buffer> <silent> <leader>ee :Semshi error<CR>
  nmap <buffer> <silent> <leader>ge :Semshi goto error<CR>
endif

if exists(':IPython')
  map  <buffer> <silent> <F5>      <Plug>(IPy-Run)
  imap <buffer> <silent> <C-F>     <Plug>(IPy-Complete)
  map  <buffer> <silent> <F8>      <Plug>(IPy-Interrupt)
  map  <buffer> <silent> <leader>? <Plug>(IPy-WordObjInfo)
endif

if exists('did_coc_loaded')
  nmap <buffer> <silent> gD <Plug>(coc-definition)
  nn   <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif
