" gzip.vim doesn't actually have any configuration options, so this is a hack
" to use faster implementations of programs when available
aug gzip
  if executable('pigz')
    au! BufReadPost,FileReadPost    *.gz
    au! BufWritePost,FileWritePost  *.gz
    au! FileAppendPre               *.gz
    au! FileAppendPost              *.gz
    au  BufReadPost,FileReadPost    *.gz  call gzip#read('pigz -dn')
    au  BufWritePost,FileWritePost  *.gz  call gzip#write('pigz')
    au  FileAppendPre               *.gz  call gzip#appre('pigz -dn')
    au  FileAppendPost              *.gz  call gzip#write('pigz')
  endif
  if executable('pbzip2')
    au! BufReadPost,FileReadPost    *.bz2
    au! BufWritePost,FileWritePost  *.bz2
    au! FileAppendPre               *.bz2
    au! FileAppendPost              *.bz2
    au  BufReadPost,FileReadPost    *.bz2 call gzip#read('pbzip2 -d')
    au  BufWritePost,FileWritePost  *.bz2 call gzip#write('pbzip2')
    au  FileAppendPre               *.bz2 call gzip#appre('pbzip2 -d')
    au  FileAppendPost              *.bz2 call gzip#write('pbzip2')
  endif
  if executable('pzstd')
    au! BufReadPost,FileReadPost    *.zst
    au! BufWritePost,FileWritePost  *.zst
    au! FileAppendPre               *.zst
    au! FileAppendPost              *.zst
    au  BufReadPost,FileReadPost    *.zst call gzip#read('pzstd -d --rm')
    au  BufWritePost,FileWritePost  *.zst call gzip#write('pzstd --rm')
    au  FileAppendPre               *.zst call gzip#appre('pzstd -d --rm')
    au  FileAppendPost              *.zst call gzip#write('pzstd --rm')
  endif
aug END
