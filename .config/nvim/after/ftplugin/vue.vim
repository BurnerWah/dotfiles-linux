" Commands
com! -buffer -nargs=0 Prettier :ALEFix prettier

" autocmds
aug user_ftplugin
  au! * <buffer>
  au CursorHold <buffer> silent call CocActionAsync('highlight')
aug END
