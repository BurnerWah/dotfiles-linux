; Despite my best attempts, function.inner just doesn't seem to be possible.

; Strings
(string) @string.any.outer
((string) @string.double.outer
 (#match? @string.double.outer "^\""))
((string) @string.single.outer
 (#match? @string.single.outer "^'"))

; Ambiguous
(field
 "["
 (_)+ @ambig.braces.inner
 "]"
) @ambig.braces.outer
