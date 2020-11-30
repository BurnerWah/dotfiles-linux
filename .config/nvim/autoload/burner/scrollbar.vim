fun! burner#scrollbar#enable_scrollbar_buffer()
  aug burner.scrollbar.buffer
    au! * <buffer>
    au CursorMoved,VimResized,QuitPre,WinEnter,FocusGained <buffer> sil! lua require('scrollbar').show()
    au WinLeave,FocusLost <buffer> sil! lua require('scrollbar').clear()
  aug END
endfun
