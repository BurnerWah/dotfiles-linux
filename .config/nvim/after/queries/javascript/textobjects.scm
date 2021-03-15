; Comments
(comment) @comment.outer

; Strings
[(string) (template_string)] @string.any.outer
(string "\"") @string.double.outer
(string "'") @string.single.outer
(template_string) @string.template.outer

; Ambiguous
; NOTE braces don't really seem to work
