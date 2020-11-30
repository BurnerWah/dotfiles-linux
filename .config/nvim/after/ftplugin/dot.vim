if exists('did_coc_loaded')
  " Maps
  nn <buffer> <silent> K :call CocActionAsync('doHover')<CR>
end

" autocmds
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    " Highlight symbol under cursor on CursorHold
    au CursorHold <buffer> silent call CocActionAsync('highlight')
  endif
aug END
