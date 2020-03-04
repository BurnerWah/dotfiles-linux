" Maps
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" autocmds
aug user_ftplugin
  au! * <buffer>
  " Highlight symbol under cursor on CursorHold
  au CursorHold <buffer> silent call CocActionAsync('highlight')
aug END
