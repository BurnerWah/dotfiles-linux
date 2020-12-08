setl tabstop=2

if exists('did_coc_loaded')
  setl formatexpr=CocAction('formatSelected')
  nn <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif
