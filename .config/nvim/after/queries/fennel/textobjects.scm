; Functions
(function_definition
 name: (identifier)?
 (parameters)
 body: (_) @function.inner
) @function.outer

; Comments
(comment)+ @comment.outer
