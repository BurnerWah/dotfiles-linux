setl formatexpr=CocAction('formatSelected')

com! -buffer -nargs=0 Prettier :CocCommand prettier.formatFile
com! -buffer -nargs=0 Tsc :CocCommand tsserver.watchBuild

let b:coc_root_patterns = ['.git', 'package.json', 'tsconfig.json', 'tslint.json']
