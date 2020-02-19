" Options
setl formatexpr=CocAction('formatSelected')

" Buffer variables
let b:coc_root_patterns = ['.git', 'package.json', 'tsconfig.json', 'tslint.json']

" Commands
com! -buffer -nargs=0 Prettier :call CocActionAsync('runCommand', 'prettier.formatFile')
com! -buffer -nargs=0 Tsc :call CocActionAsync('runCommand', 'tsserver.watchBuild')

" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
