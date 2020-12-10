; Bash parser improvements

; Issues:
; - $!, $# - broken
; - ${!}, ${#} - broken

[
 "[[" "]]"
 "((" "))"
 ] @punctuation.bracket

[
 "!"
 "=~"
 ] @operator

(case_item
  fallthrough: [";&" ";;&"] @punctuation.delimiter)

(pipeline ["|" "|&"] @operator)

(variable_assignment ["=" "+="] @operator)

(file_redirect
  ["<" ">" ">>" "&>" "&>>" "<&" ">&" ">|"] @operator)

(heredoc_redirect ["<<" "<<-"] @operator)

(herestring_redirect "<<<" @operator)

(binary_expression
  operator: [
   "="  "==" "=~" "!="
   "+"  "-"  "+=" "-="
   "<"  ">"  "<=" ">="
   "||" "&&"
   ] @operator)

(ternary_expression "?" @operator ":" @operator)

(postfix_expression ["++" "--"] @operator)

(expansion
  [":" ":?" "=" ":-" "%" "-" "#"] @operator)

(process_substitution  ["<(" ">("] @punctuation.bracket)
