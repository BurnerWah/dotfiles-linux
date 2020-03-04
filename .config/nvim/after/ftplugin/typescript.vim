" Options
setl formatexpr=CocAction('formatSelected')

" Commands
com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')
com! -buffer -nargs=0 Tsc :call CocActionAsync('runCommand', 'tsserver.watchBuild')

" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" autocmds
aug user_ftplugin
  au! * <buffer>
  au CursorHold <buffer> silent call CocActionAsync('highlight')
aug END
