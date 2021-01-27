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

if exists('did_coc_loaded')
  nmap <buffer> <silent> gD <Plug>(coc-definition)
  nn   <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif
