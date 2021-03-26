-- LuaRocks configuration
lua_interpreter = 'luajit'
home_tree = home .. '/.local'
homeconfdir = home .. '/.config/luarocks'
lib_modules_path = '/lib64/lua/' .. lua_version
local_by_default = true
check_certificates = true
rocks_trees = {
  {name = 'local', root = home .. '/.local'}, {name = 'syslocal', root = '/usr/local'},
  {name = 'system', root = '/usr'},
  {name = 'nvim', root = home .. '/.local/share/nvim/site/pack/user/start/rocks-tree'},
  -- This lets nvim + luarocks sequence correctly
}
variables = {
  AR = 'llvm-ar',
  CC = 'clang',
  CXX = 'clang++',
  GUNZIP = 'unpigz',
  LD = 'clang',
  RANLIB = 'llvm-ranlib',
  WGET = 'false',
}
