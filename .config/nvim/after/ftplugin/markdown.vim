" Markdown is currently only used for checkhealth, so I guess we can just
" sorta do whatever we want here.
" ftpluigns are sourced too early for us to set nomodifable, so instead we use
" an autocmd to try and make sure the user never has a chance to modify the
" buffer.
" ftplugins are also sourced too late for us to disable Coc.nvim for this
" buffer. I think ALE gets disabled (if not use ALEDisableBuffer) so no
" problems there.
" setl nospell
" let [b:coc_suggest_disable, b:coc_diagnostic_disable] = [1, 1]
" let b:ale_enabled = 0
" au CursorHold,CursorMoved,InsertEnter <buffer> ++once setl nomodifiable
