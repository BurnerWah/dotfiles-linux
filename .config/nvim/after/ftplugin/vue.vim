if exists(':ALEFix')
  " Commands
  com! -buffer -nargs=0 Prettier :ALEFix prettier
endif

" autocmds
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    au CursorHold <buffer> silent call CocActionAsync('highlight')
  endif
aug END
