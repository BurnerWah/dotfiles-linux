if !exists('b:is_jsonc')
  ru! ftplugin/json.vim
endif

" Comments
setl commentstring=//%s comments=s1:/*,mb:*,ex:*/,://
