setl formatexpr=CocAction('formatSelected')
setl foldmethod=syntax
com! -buffer -nargs=0 Prettier :ALEFix prettier
if exists('b:is_jsonc')
  setl commentstring=//%s comments=s1:/*,mb:*,ex:*/,://
endif
