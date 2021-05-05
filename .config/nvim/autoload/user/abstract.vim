function! user#abstract#editorconfig_hook(config)
  return luaeval('require("plugins.editorconfig-vim").hook(_A)', a:config)
endfunction
