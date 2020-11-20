" let b:source_func = 's:get_hunks_empty'
let b:ale_enabled = 0
let [b:coc_enabled,  b:coc_suggest_disable, b:coc_diagnostic_disable] = [0, 1, 1]
aug user_ftplugin
  au! * <buffer>
aug END
