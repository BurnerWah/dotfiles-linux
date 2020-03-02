" Partially renders out nroff/groff files to make them readable.
" seriously roff is a nightmare language.

syn region nroffBold concealends keepend
      \ matchgroup=nroffBoldDelim
      \ start=+\\f\%(B\|\[B\]\)+
      \ skip=+\\f\%(I\|\[I\]\)+
      \ end=+\\f\%([PR]\?\|\[[PR]\?\]\)+
      \ contains=TOP
syn region nroffBold oneline
      \ matchgroup=nroffBoldReq
      \ start=+^[.']B\ze\s\++
      \ end=+$+
      \ contains=TOP

syn region nroffUnderline concealends keepend
      \ matchgroup=nroffUnderlineDelim
      \ start=+\\f\%(I\|\[I\]\)+
      \ skip=+\\f\%(B\|\[B\]\)+
      \ end=+\\f\%([PR]\?\|\[[PR]\?\]\)+
      \ contains=TOP,@Spell
syn region nroffUnderline oneline
      \ matchgroup=nroffUnderlineReq
      \ start=+^[.']I\ze\s\++
      \ end=+$+
      \ contains=TOP
" Spell is excluded to prevent undercurl from overriding underline

syn match nroffHidden /\\\%([?!-]\)\@=/ contained containedin=nroffSpecialChar transparent conceal

syn match nroffNoControl /\\&[.']/
syn match nroffHidden /\\&/ contained containedin=nroffNoControl transparent conceal

hi def nroffBold term=bold cterm=bold gui=bold
hi def link nroffBoldDelim nroffEscape
hi def link nroffBoldReq nroffRequest
hi def nroffUnderline term=underline cterm=underline gui=underline
hi def link nroffUnderlineDelim nroffEscape
hi def link nroffUnderlineReq nroffRequest
hi def link nroffNoControl nroffSpecialChar
