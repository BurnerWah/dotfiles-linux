" Options
setl formatexpr=CocAction('formatSelected')
setl foldmethod=syntax

" Buffer variables
let b:undo_ftplugin = join([
      \ get(b:, 'undo_ftplugin', ''),
      \ 'exe "au! user_ftplugin_json * <buffer>"',
      \ ], ' | ')

" Commands
com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')

" Maps
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" autocmds
aug user_ftplugin_json
  au! * <buffer>
  au BufWritePre <buffer> call CocAction('runCommand', 'prettier.formatFile')
aug END

" JSON W/ Comments
if exists('b:is_jsonc')
  setl commentstring=//%s comments=s1:/*,mb:*,ex:*/,://
endif
