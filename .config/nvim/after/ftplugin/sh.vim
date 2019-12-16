" Bash
if get(b:, 'is_bash')
  nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif
