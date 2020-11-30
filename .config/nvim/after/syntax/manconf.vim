" Fix spelling issues
syn region manconfComment display oneline start='^#' end='$' contains=manconfTodo,@Spell

syn match manconfNumber contained /\d\+/
syn keyword manconfDefineKeyword contained
      \ pager cat tr grep troff nroff eqn neqn tbl col vgrind refer grap pic
      \ nextgroup=manconfCommand skipwhite
syn keyword manconfDefineKeyword contained
      \ compressor whatis_grep_flags apropos_grep_flags apropos_regex_grep_flags

" Add missing keywords
syn keyword manconfKeyword contained MANDB_MAP nextgroup=manconfFirstPath skipwhite
syn keyword manconfKeyword contained MANDATORY_MANPATH nextgroup=manconfPath skipwhite
syn keyword manconfKeyword contained SECTION nextgroup=manconfManSect skipwhite

" TODO add next keyword for DEFINE
syn keyword manconfKeyword contained DEFINE nextgroup=manconfDefineKeyword skipwhite

syn keyword manconfKeyword contained MINCATWIDTH MAXCATWIDTH CATWIDTH
      \ nextgroup=manconfNumber skipwhite

hi def link manconfNumber Number
hi def link manconfDefineKeyword Statement
