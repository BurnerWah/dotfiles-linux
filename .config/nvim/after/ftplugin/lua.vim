" Use tree-sitter handle folding
setl foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
setl foldlevel=1

if exists('did_coc_loaded')
  " Maps
  nmap <buffer> <silent> gD <Plug>(coc-definition)
  nn   <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif
