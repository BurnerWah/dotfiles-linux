; Comments
(comment) @comment.outer

; Strings
[(string) (quoted_key)] @string.any.outer

([(string     "\"" @_start ((_)+)? "\"" @_end)
  (quoted_key "\"" @_start ((_)+)? "\"" @_end)]
  (#make-range! "string.double.outer" @_start @_end))
([(string     "'" @_start "'" @_end)
  (quoted_key "'" @_start "'" @_end)]
  (#make-range! "string.single.outer" @_start @_end))

; Ambiguous
(array) @ambig.braces.outer
([(table "[" @_start (_)+ "]" @_end)
  (table_array_element "[[" @_start (_)+ "]]" @_end)]
  (#make-range! "ambig.braces.outer" @_start @_end))
(inline_table) @ambig.brackets.outer
