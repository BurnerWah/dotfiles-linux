" Buffer variables
let b:coc_root_patterns = ['.git', 'compile_commands.json', '.ccls', '.ccls-root']

" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
