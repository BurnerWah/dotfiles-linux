setl formatexpr=CocAction('formatSelected')
setl foldmethod=syntax
if exists('b:is_jsonc')
  setl commentstring=//%s comments=s1:/*,mb:*,ex:*/,://
endif
