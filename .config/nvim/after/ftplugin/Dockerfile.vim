" Coc.nvim
if exists('did_coc_loaded')
  setl formatexpr=CocAction('formatSelected')
  " Maps
  nn <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif

" autocmds
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    " Highlight symbol under cursor on CursorHold
    au CursorHold <buffer> silent call CocActionAsync('highlight')
  endif
aug END
