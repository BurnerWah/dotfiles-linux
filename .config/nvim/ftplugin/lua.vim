" Buffer variables
let b:coc_root_patterns = ['.git', '.luacheckrc']

" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
