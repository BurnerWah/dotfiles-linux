" Use tree-sitter handle folding
setl foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

if exists('did_coc_loaded')
  " Options
  setl formatexpr=CocAction('formatSelected')

  " Commands
  com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')
  com! -buffer -nargs=0 Tsc :call CocActionAsync('runCommand', 'tsserver.watchBuild')

  " Maps
  nmap <buffer> <silent> gD <Plug>(coc-definition)
  nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif

" autocmds
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    au CursorHold <buffer> silent call CocActionAsync('highlight')
  endif
aug END
