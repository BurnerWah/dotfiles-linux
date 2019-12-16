" Buffer variables
let b:coc_root_patterns = ['.git', 'Cargo.toml', 'rustfmt.toml']

" Maps
nmap <buffer> <silent> gD <Plug>(coc-definition)
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
