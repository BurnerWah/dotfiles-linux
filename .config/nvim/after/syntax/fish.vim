" Injects better syntax for fish scripts

" Cleanup
syn clear fishComment
syn clear fishIdentifier
syn clear fishString
syn clear fishCharacter

" Comments
syn region fishComment oneline start=/\s*\zs#/ end=/$/ contains=@spell,fishTodo
syn keyword fishTodo contained TODO FIXME XXX NOTE

" Strings
syntax region fishString start=/'/ skip=/\%(\\\{2}\)\|\%(\\\)'/ end=/'/ contains=fishCharacter
syntax region fishString start=/"/ skip=/\%(\\\{2}\)\|\%(\\\)"/ end=/"/ contains=fishIdentifier,fishCharacter

" Characters
syn match fishCharacter /\\[abefnrtv*?~%#(){}\[\]<>&;"'^]/
syn match fishCharacter /\\\s/
syn match fishCharacter /\c\\x\x\{1,2}/
syn match fishCharacter /\\o\o\{1,2}/
syn match fishCharacter /\\u\x\{1,4}\|\\U\x\{1,8}/
syn match fishCharacter /\\c\a/

" Other
syntax match fishIdentifier /\$\w\+/

" Highlights
hi def link fishTodo Todo
