; Heredoc stuff
; I don't think it's possible to get good offsets due to how the bash parser is written.
; Basically, the end of a heredoc is still a part of the heredoc.
; So for the most part, this just assumes that the heredoc's EOF is always set to EOF.
;
; Only a few things actually get included, but that depends on the file contents so that's fine.

; Python
(((redirected_statement
    body: (command
     name: (command_name (word) @_cmd))
    redirect: (heredoc_redirect (heredoc_start)))
  ((heredoc_body) @python
   (#offset! @python 0 0 0 -3)))
 (#match? @_cmd "^(python[\d.]*)"))

; JS
(((redirected_statement
    body: (command
     name: (command_name (word) @_cmd))
    redirect: (heredoc_redirect (heredoc_start)))
  ((heredoc_body) @javascript
   (#offset! @javascript 0 0 0 -3)))
 (#eq? @_cmd "node"))

; Typescript
(((redirected_statement
    body: (command
     name: (command_name (word) @_cmd))
    redirect: (heredoc_redirect (heredoc_start)))
  ((heredoc_body) @typescript
   (#offset! @typescript 0 0 0 -3)))
 (#eq? @_cmd "deno"))

; Ruby
(((redirected_statement
    body: (command
     name: (command_name (word) @_cmd))
    redirect: (heredoc_redirect (heredoc_start)))
  ((heredoc_body) @ruby
   (#offset! @ruby 0 0 0 -3)))
 (#eq? @_cmd "ruby"))

; Lua
; It's actually possible to cover lua -e, but it looks terrible.
(((redirected_statement
    body: (command
     name: (command_name (word) @_cmd))
    redirect: (heredoc_redirect (heredoc_start)))
  ((heredoc_body) @lua
   (#offset! @lua 0 0 0 -3)))
 (#match? @_cmd "^(lua|luajit)"))
