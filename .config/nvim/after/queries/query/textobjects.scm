; Comments
(comment) @comment.outer

; Strings
(("\"" @_start ((_)+)? "\"" @_end)
 (#make-range! "string.double.outer" @_start @_end))

; Ambigous
((list "[" @_start (_)+ "]" @_end)
 (#make-range! "ambig.braces.outer" @_start @_end))

(predicate) @ambig.parens.outer
([(named_node "(" @_start (_)+ ")" @_end)
  (grouping   "(" @_start (_)+ ")" @_end)]
  (#make-range! "ambig.parens.outer" @_start @_end))
