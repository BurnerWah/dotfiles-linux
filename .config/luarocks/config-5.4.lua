-- LuaRocks configuration
home_tree = home .. '/.local'
homeconfdir = home .. '/.config/luarocks'
lib_modules_path = '/lib64/lua/' .. lua_version
local_by_default = true
rocks_trees = {
  {name = 'local', root = home .. '/.local'}, {name = 'syslocal', root = '/usr/local'},
  {name = 'system', root = '/usr'},
}
variables = {
  AR = 'llvm-ar',
  CC = 'clang',
  CXX = 'clang++',
  GUNZIP = 'unpigz',
  LD = 'clang',
  RANLIB = 'llvm-ranlib',
}
