-- LuaRocks configuration
lua_interpreter = "luajit"
home_tree = home .. "/.local"
homeconfdir = home .. "/.config/luarocks"
local_by_default = true
check_certificates = true
rocks_trees = {
	{ name = "local", root = home .. "/.local" },
	{ name = "syslocal", root = "/usr/local" },
	{ name = "system", root = "/usr" },
}
variables = {
	AR = "llvm-ar",
	CC = "clang",
	CXX = "clang++",
	GUNZIP = "unpigz",
	LD = "clang",
	RANLIB = "llvm-ranlib",
}
