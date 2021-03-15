; Defaults to @constant.builtin
(boolean) @boolean

[
 "[" "]"
 "[[" "]]"
 "{" "}"
 ] @punctuation.bracket

(array "," @punctuation.delimiter)

(pair "=" @operator)

(dotted_key "." @punctuation.delimiter)

(quoted_key) @type.builtin
(pair (quoted_key) @property)
