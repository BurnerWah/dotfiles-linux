" Buffer variables
let b:coc_root_patterns = ['.git', 'go.mod', 'Gopkg.toml']
let b:undo_ftplugin = join([
      \ get(b:, 'undo_ftplugin', ''),
      \ 'exe "au! user_ftplugin_go * <buffer>"',
      \ ], ' | ')

" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nmap <buffer> <silent> <C-]> <Plug>(coc-definition)
nmap <buffer> <silent> <C-LeftMouse> <LeftMouse> <Plug>(coc-definition)
nmap <buffer> <silent> g<LeftMouse> <LeftMouse> <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" autocmds
aug user_ftplugin_go
  au! * <buffer>
  au BufWritePre <buffer> call CocAction('runCommand', 'editor.action.organizeImport')
aug END
