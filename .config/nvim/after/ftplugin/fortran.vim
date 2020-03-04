" autocmds
aug user_ftplugin
  au! * <buffer>
  au CursorHold <buffer> silent call CocActionAsync('highlight')
aug END
