" This is to fix conflicts with coc
if str2nr(vimwiki#vars#get_global('key_mappings').table_mappings)
  inor <expr><buffer> <Tab>   pumvisible() ? "\<C-n>" : vimwiki#tbl#kbd_tab()
  inor <expr><buffer> <S-Tab> pumvisible() ? "\<C-p>" : vimwiki#tbl#kbd_shift_tab()
endif

if expand('%') =~# '.wiki$'
  " Disable markdown-only linters for vimwiki
  let b:ale_linters = ['alex', 'languagetool', 'proselint', 'redpen', 'textlint', 'vale', 'writegood']
endif

" Why is this needed? There shouldn't be any autocmds for vimwiki buffers in
" the first place so... Why the coc highlighting CursorHold get initialized?
" On markdown files specifically?
aug user_ftplugin
  au! * <buffer>
aug END
