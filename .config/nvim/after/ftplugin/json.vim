" Options
setl formatexpr=CocAction('formatSelected')
setl fdm=syntax

" Commands
com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')

" Maps
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" autocmds
aug user_ftplugin_json
  au! * <buffer>
  au BufWritePre <buffer> call CocAction('runCommand', 'prettier.formatFile')
aug END
