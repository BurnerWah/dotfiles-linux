" Use rst2ctags for ctags if available
if exists('vista_ctags_cmd') && executable('rst2ctags')
  let vista_ctags_cmd['rst'] = get(g:vista_ctags_cmd, 'rst', 'rst2ctags')
endif
