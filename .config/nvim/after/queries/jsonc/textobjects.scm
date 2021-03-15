; Comments
(comment) @comment.outer

; Strings
(string) @string.double.outer
(string_content) @string.double.inner

; Ambiguous
(object
 "{"
 (_)+ @ambig.brackets.inner
 "}") @ambig.brackets.outer
(array
 "["
 (_)+ @ambig.braces.inner
 "]") @ambig.braces.outer
