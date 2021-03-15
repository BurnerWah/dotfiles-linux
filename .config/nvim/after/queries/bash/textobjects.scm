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
