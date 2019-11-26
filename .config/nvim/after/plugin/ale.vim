" ALE Configuration
" The two main lint engines I've seen for Vim are ALE and Syntastic. Both are
" extensible engines, but I've noticed that ALE seems to have better
" integration with nvim, and the window syntastic opens up all the time makes
" it a bit of a pain in the ass to edit files that you're actively ignoring
" something in.
"
" Most linters are on by default.
" The following tools are intentionally disabled:
"   ccls: Better handled by coc.nvim
"   rls: Redundant w/ coc-rls
"   pyls: Redundant w/ coc-pyls
"   gopls: Redundant w/ coc-go

let g:ale_linters = {
      \   'c': [
      \     'clang', 'clangd', 'clang-format', 'clangtidy', 'cppcheck',
      \     'cpplint', 'cquery', 'flawfinder', 'gcc', 'uncrustify',
      \   ],
      \   'cpp': [
      \     'clang', 'clangcheck', 'clangd', 'clangtidy', 'clazy',
      \     'cppcheck', 'cpplint', 'cquery', 'flawfinder', 'gcc', 'uncrustify',
      \   ],
      \   'css': ['csslint', 'fecs'],
      \   'lua': ['luac'],
      \   'markdown': [
      \     'alex', 'languagetool', 'mdl', 'proselint', 'redpen',
      \     'remark_lint', 'textlint', 'vale', 'writegood',
      \   ],
      \   'objc': ['clang', 'clangd', 'uncrustify'],
      \   'python': ['flake8', 'mypy'],
      \   'sass': ['sasslint'],
      \   'scss': ['sasslint', 'scsslint'],
      \   'sh': ['shell', 'shellcheck'],
      \   'tex': [
      \     'alex', 'chktex', 'lacheck', 'proselint', 'redpen',
      \     'textlint', 'vale', 'writegood',
      \   ],
      \   'yaml': ['swaglint'],
      \ }

let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \
      \   'xml': ['xmllint'],
      \
      \   'cmake': ['cmakeformat', 'remove_trailing_lines', 'trim_whitespace'],
      \   'cpp': [
      \     'clang-format', 'clangtidy', 'uncrustify',
      \     'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'go': [
      \     'gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace',
      \   ],
      \   'python': [
      \     'add_blank_lines_for_python_control_statements',
      \   ],
      \   'rust': ['rustfmt', 'remove_trailing_lines', 'trim_whitespace'],
      \   'sh': ['shfmt', 'remove_trailing_lines', 'trim_whitespace'],
      \   'sql': ['sql-format', 'remove_trailing_lines', 'trim_whitespace'],
      \ }

let g:ale_fix_on_save = v:true
