let s:save_cpo = &cpo
set cpo&vim

" Commands
com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')

" Maps
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>

" Undo ftplugin
let b:undo_ftplugin = join([
      \   get(b:, 'undo_ftplugin', ''),
      \   'delc Prettier',
      \   'nunm <buffer> K',
      \ ], ' | ')

let &cpo = s:save_cpo
unl s:save_cpo
