" Lazy-loaded clap source for todoist
" This is only really used so it gets included in Clap completions
let s:save_cpo = &cpoptions
set cpoptions&vim

let s:todoist = {}

let s:todoist['source'] = { -> Todoist__listProjects() }
let s:todoist['sink'] = 'Todoist'

let g:clap#provider#todoist# = s:todoist

let &cpoptions = s:save_cpo
unlet s:save_cpo
