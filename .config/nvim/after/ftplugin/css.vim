if exists('did_coc_loaded')
  " Options
  setl formatexpr=CocAction('formatSelected')

  " Commands
  com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')

  " Maps
  nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif

" autocmds
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    " Highlight symbol under cursor on CursorHold
    au CursorHold <buffer> silent call CocActionAsync('highlight')
  endif
aug END
