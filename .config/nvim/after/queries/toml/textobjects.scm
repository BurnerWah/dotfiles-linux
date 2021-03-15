; Comments
(comment) @comment.outer

; Strings
(string) @string.any.outer

((string) @_s
 (#match? @_s "^\"[^\"]{2}")) @string.double.outer
((string) @_s
 (#eq? @_s "\"\"")) @string.double.outer
((quoted_key) @_s
 (#match? @_s "^\"")) @string.double.outer

((string) @_s
 (#match? @_s "^'[^']{2}")) @string.single.outer
((string) @_s
 (#eq? @_s "''")) @string.single.outer
((quoted_key) @_s
 (#match? @_s "^'")) @string.single.outer
