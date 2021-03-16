; Despite my best attempts, function.inner just doesn't seem to be possible.

; Strings
(string) @string.any.outer
((string) @string.double.outer
 (#match? @string.double.outer "^\""))
((string) @string.single.outer
 (#match? @string.single.outer "^'"))

; Ambiguous
([(variable_declarator "[" @_start (_)+ @ambig.braces.inner "]" @_end)
  (field               "[" @_start (_)+ @ambig.braces.inner "]" @_end)]
  (#make-range! "ambig.braces.outer" @_start @_end))

(("(" @_start (_)+ ")" @_end)
 (#make-range! "ambig.parens.outer" @_start @_end))
