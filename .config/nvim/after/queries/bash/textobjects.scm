; strings
[
 (string)
 (raw_string)
 (ansii_c_string)
] @string.any.outer

(string) @string.double.outer
[
 (raw_string)
 (ansii_c_string)
] @string.single.outer

; ambiguous
(command_substitution
 "`"
 (_)+ @ambig.tilde.inner
 "`"
) @ambig.tilde.outer

[
  (process_substitution (_)+ @ambig.parens.inner)
  (command_substitution "$(" (_)+ @ambig.parens.inner ")")
  (array (_)+ @ambig.parens.inner)
  (parenthesized_expression (_)+ @ambig.parens.inner)
  (subshell (_)+ @ambig.parens.inner) ; Inner gets lost somehow
] @ambig.parens.outer
([(c_style_for_statement "((" @_start (_)+ @ambig.parens.inner "))" @_end)
  (test_command          "((" @_start (_)+ @ambig.parens.inner "))" @_end)]
  (#make-range! "ambig.parens.outer" @_start @_end))
