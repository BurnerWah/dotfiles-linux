local fn, mt = {}, {}

local fnproxy = require('vlib.fnproxy')

-- TODO add support for deprecating access to functions

local String = fnproxy.String
local Bool = fnproxy.Bool
local Int = fnproxy.Int
local Void = fnproxy.Void

local metadata = {
  bufexists = Bool, -- Might be wrong?
  buflisted = Bool,
  bufloaded = Bool,
  bufname = String, -- I think this is right?
  bufnr = Int,
  bufwinid = Int,
  bufwinnr = Int,
  complete_check = Bool, -- Might be wrong?
  did_filetype = Bool,
  empty = Bool,
  eventhandler = Bool, -- Probably should have a different name
  executable = Bool,
  exepath = String,
  exists = Bool,
  feedkeys = Void, -- Maybe should be deprecated
  filereadable = Bool,
  finddir = String,
  findfile = String,
  foldclosed = Int,
  foldclosedend = Int,
  foldtextresult = String,
  getfperm = String, -- Maybe should be deprecated
  getftime = Int, -- Maybe should be deprecated
  getftype = String, -- Maybe should be deprecated
  getreg = String,
  getwinposx = Int,
  getwinposy = Int,
  has = Bool,
  haslocaldir = Bool,
  hasmapto = Bool,
  histdel = Bool, -- Maybe this should throw an error when it fails?
  histget = String,
  histnr = Int,
  indent = Int, -- Maybe should throw an error on -1.
  inputrestore = Bool, -- 1 if there is nothing to restore.
  inputsave = Bool, -- Probably should throw error, as 1 means OOM
  isdirectory = Bool,
  islocked = Bool, -- Might not be all that useful
  line2byte = Int,
  lispindent = Int, -- -1 is on error
  reg_executing = String,
  reg_recording = String,
  serverstop = Bool,
}

function mt.__index(_, name)
  local found = metadata[name]
  rawset(fn, name, (found and found(name) or vim.fn[name]))
  return fn[name]
end
setmetatable(fn, mt)
return fn
