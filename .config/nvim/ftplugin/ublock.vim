if exists('b:did_ftplugin')
  finish
endif

let b:did_ftplugin = 1
let s:save_cpo = &cpoptions

setl comments=:! commentstring=!%s

let &cpoptions = s:save_cpo
unlet s:save_cpo
