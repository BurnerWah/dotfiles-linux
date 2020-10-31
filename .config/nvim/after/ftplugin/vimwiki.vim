" This is to fix conflicts with coc
if str2nr(vimwiki#vars#get_global('key_mappings').table_mappings)
  inoremap <expr><buffer> <Tab>   pumvisible() ? "\<C-n>" : vimwiki#tbl#kbd_tab()
  inoremap <expr><buffer> <S-Tab> pumvisible() ? "\<C-p>" : vimwiki#tbl#kbd_shift_tab()
endif
