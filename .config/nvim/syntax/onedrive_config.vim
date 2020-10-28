if exists('b:current_syntax')
  fini
en

let s:cpo_save = &cpoptions
set cpoptions&vim

syn region onedriveComment oneline fold start='^#' end='$' contains=@spell,onedriveTodo
syn keyword onedriveTodo contained TODO FIXME XXX NOTE
" syn match onedriveLine transparent /^.*$/ contains=onedriveKey,onedriveComment
syn keyword onedriveKey
      \ application_id azure_ad_endpoint azure_tenant_id bypass_data_preservation
      \ check_nomount check_nosync classify_as_big_delete debug_https
      \ disable_notifications disable_upload_validation download_only drive_id
      \ dry_run enable_logging force_http_11 force_http_2 local_first log_dir
      \ min_notify_changes monitor_fullscan_frequency monitor_interval
      \ monitor_log_frequency no_remote_delete remove_source_files resync
      \ skip_dir skip_dir_strict_match skip_dotfiles skip_file skip_symlinks
      \ sync_business_shared_folders sync_dir sync_root_files upload_only
      \ user_agent
      \ nextgroup=onedriveOperator skipwhite
syn match onedriveOperator contained /=/ nextgroup=@onedriveStrings skipwhite
syn cluster onedriveStrings contains=onedriveString,onedriveBool,onedriveNum
syn match onedriveString contained /""/
syn region onedriveString contained concealends
      \ matchgroup=onedriveStringEdge start=+"\ze[^"]+
      \ skip=+\\\\\|\\"+
      \ matchgroup=onedriveStringEdge end=+"+
      \ contains=onedriveStrOp,onedriveWildcard
syn region onedriveBool contained concealends
      \ matchgroup=onedriveStringEdge start=+"\zetrue"+
      \ matchgroup=onedriveStringEdge start=+"\zefalse"+
      \ matchgroup=onedriveStringEdge end=+"+
syn region onedriveNum contained concealends
      \ matchgroup=onedriveStringEdge start=+"\ze\d\+"+
      \ matchgroup=onedriveStringEdge end=+"+
syn match onedriveStrOp contained /|/
syn match onedriveWildcard contained /[?*]/

hi def link onedriveComment Comment
hi def link onedriveTodo Todo
hi def link onedriveKey Identifier
hi def link onedriveOperator Operator
hi def link onedriveString String
hi def link onedriveStringEdge onedriveString
hi def link onedriveBool Boolean
hi def link onedriveNum Number
hi def link onedriveStrOp Operator
hi def link onedriveWildcard Special

let b:current_syntax = 'onedrive_config'

let &cpoptions = s:cpo_save
unlet s:cpo_save
