" This is to fix conflicts with coc
if str2nr(vimwiki#vars#get_global('key_mappings').table_mappings)
  inor <expr><buffer> <Tab>   pumvisible() ? "\<C-n>" : vimwiki#tbl#kbd_tab()
  inor <expr><buffer> <S-Tab> pumvisible() ? "\<C-p>" : vimwiki#tbl#kbd_shift_tab()
endif

if expand('%') =~# '.wiki$'
  " Disable markdown-only linters for vimwiki
  let b:ale_linters = ['alex', 'languagetool', 'proselint', 'redpen', 'textlint', 'vale', 'writegood']
endif

" This adds markdown preview support, but I haven't found a good way to ensure
" that the plugin is actually installed.
com! -buffer MarkdownPreview call mkdp#util#open_preview_page()
nore <buffer> <silent> <Plug>MarkdownPreview :call mkdp#util#open_preview_page()<CR>
inor <buffer> <silent> <Plug>MarkdownPreview <Esc>:call mkdp#util#open_preview_page()<CR>a
nore <buffer> <silent> <Plug>MarkdownPreviewStop :call mkdp#util#stop_preview()<CR>
inor <buffer> <silent> <Plug>MarkdownPreviewStop <Esc>:call mkdp#util#stop_preview()<CR>a
nnor <buffer> <silent> <Plug>MarkdownPreviewToggle :call mkdp#util#toggle_preview()<CR>
inor <buffer> <silent> <Plug>MarkdownPreviewToggle <Esc>:call mkdp#util#toggle_preview()<CR>
