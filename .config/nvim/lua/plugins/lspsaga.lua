local codicons = require("codicons")

require("lspsaga").init_lsp_saga({
  error_sign = codicons.get("error") or "",
  warn_sign = codicons.get("warning") or "",
  hint_sign = codicons.get("question") or "",
  infor_sign = codicons.get("info") or "",
  diagnostic_header_icon = " " .. codicons.get("bug") .. "  ",
  code_action_icon = codicons.get("lightbulb") .. " ",
  code_action_prompt = { virtual_text = false },
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    quit = { "q", "<Esc>" },
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  code_action_keys = { quit = { "q", "<Esc>" }, exec = "<CR>" },
  rename_action_keys = { quit = { "<C-c>", "<Esc>" }, exec = "<CR>" },
})
