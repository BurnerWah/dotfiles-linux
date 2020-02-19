" Buffer variables
let b:coc_root_patterns = ['.git', 'CMakeLists.txt']

" Maps
nnor <buffer> <silent> K :call CocActionAsync('doHover')<CR>
