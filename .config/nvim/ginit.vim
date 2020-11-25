if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
  call rpcnotify(1, 'Gui', 'Font', 'Fira Code 10')
endif

if exists('g:fvim_loaded')
  set guifont=JetBrains\ Mono:h14
  FVimCursorSmoothMove v:true
  FVimFontAntialias v:true
  FVimFontAutohint v:true
  FVimFontHintLevel 'full'
  FVimFontLigature v:true
  FVimFontLineHeight '+1.0'
  FVimFontSubpixel v:true
  FVimUIPopupMenu v:false
  " This has weird scrollbars that we don't want
endif

aug ginit
  au!
  " Mitigation for https://github.com/neovim/neovim/issues/13196
  au VimEnter * set conceallevel=0
aug END
