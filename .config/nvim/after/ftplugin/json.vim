setl fdm=syntax

if exists('did_coc_loaded')
  setl formatexpr=CocAction('formatSelected')

  com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')

  nn <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif

" autocmds
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    au BufWritePre <buffer> call CocAction('runCommand', 'prettier.formatFile')
  endif
aug END
