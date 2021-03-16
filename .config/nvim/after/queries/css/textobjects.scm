; Comments
(comment) @comment.outer

; Ambiguous
[
  (block)
  (keyframe_block_list)
] @ambig.brackets.outer

(arguments     (_)+ @ambig.parens.inner) @ambig.parens.outer
(feature_query (_)+ @ambig.parens.inner) @ambig.parens.outer ; I don't think this works
(parenthesized_query (_)+ @ambig.parens.inner) @ambig.parens.outer
((selector_query "(" @_start (_)+ @ambig.parens.inner ")" @_end)
 (#make-range! "ambig.parens.outer" @_start @_end))
