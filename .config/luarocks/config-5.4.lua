-- LuaRocks configuration
home_tree   = home .. "/.local"
homeconfdir = home .. "/.config/luarocks"
local_cache = home .. "/.cache/luarocks"

-- deploy_lib_dir = "/usr/lib64/lua/5.4"
lib_modules_path = "/lib64/lua/5.4"
-- rocks_subdir = "/lib64/luarocks/rocks-5.4"

rocks_trees = {
  { name = "local",    root = home .. "/.local" };
  { name = "syslocal", root = "/usr/local"      };
  { name = "system",   root = "/usr"            };
}

-- variables = {
--   LUA_DIR    = "/usr";
--   LUA_BINDIR = "/usr/bin";
--   LUA_LIBDIR = "/usr/lib64";
-- }
