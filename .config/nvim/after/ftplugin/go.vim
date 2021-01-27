" Use tree-sitter handle folding
setl foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

" Coc.nvim
if exists('did_coc_loaded')
  " Maps
  nmap <buffer> <silent> gD <Plug>(coc-definition)
  nmap <buffer> <silent> <C-]> <Plug>(coc-definition)
  nmap <buffer> <silent> <C-LeftMouse> <LeftMouse> <Plug>(coc-definition)
  nmap <buffer> <silent> g<LeftMouse> <LeftMouse> <Plug>(coc-definition)
  nn   <buffer> <silent> K :call CocActionAsync('doHover')<CR>
endif

" augroup
aug user_ftplugin
  au! * <buffer>
  if exists('did_coc_loaded')
    au BufWritePre <buffer> call CocAction('runCommand', 'editor.action.organizeImport')
    au CursorHold <buffer> silent call CocActionAsync('highlight')
  endif
aug END
