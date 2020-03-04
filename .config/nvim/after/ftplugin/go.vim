" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nmap <buffer> <silent> <C-]> <Plug>(coc-definition)
nmap <buffer> <silent> <C-LeftMouse> <LeftMouse> <Plug>(coc-definition)
nmap <buffer> <silent> g<LeftMouse> <LeftMouse> <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" autocmds
aug user_ftplugin
  au! * <buffer>
  au BufWritePre <buffer> call CocAction('runCommand', 'editor.action.organizeImport')
  au CursorHold <buffer> silent call CocActionAsync('highlight')
aug END
