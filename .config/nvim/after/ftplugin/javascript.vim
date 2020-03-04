" Commands
com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')

" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" autocmds
aug user_ftplugin
  au! * <buffer>
  au CursorHold <buffer> silent call CocActionAsync('highlight')
aug END
