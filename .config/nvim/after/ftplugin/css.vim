setl formatexpr=CocAction('formatSelected')
com! -buffer -nargs=0 Prettier :CocCommand prettier.formatFile
