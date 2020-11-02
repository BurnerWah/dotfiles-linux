if exists('did_coc_loaded')
  nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif

" autocmds
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    au CursorHold <buffer> silent call CocActionAsync('highlight')
  endif
aug END
