" Options
" Allow building terminfo entries w/ :make (if tic is available)
let &l:makeprg = executable('tic') ? 'tic' : &makeprg
