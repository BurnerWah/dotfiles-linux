if exists('b:did_ftplugin')|fini|en
let b:did_ftplugin = 1
let s:save_cpo = &cpoptions

setl commentstring=#%s
setl comments=:#

let &cpoptions = s:save_cpo
unlet s:save_cpo
