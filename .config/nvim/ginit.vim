if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
  call rpcnotify(1, 'Gui', 'Font', 'Fira Code 10') 
endif
