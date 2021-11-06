local action = require("diffview.config").diffview_callback

require("diffview").setup({
  file_panel = { width = 35, use_icons = true },
  key_bindings = {
    view = {
      ["<tab>"] = action("select_next_entry"), -- Open the diff for the next file
      ["<s-tab>"] = action("select_prev_entry"), -- Open the diff for the previous file
      ["<leader>e"] = action("focus_files"), -- Bring focus to the files panel
      ["<leader>b"] = action("toggle_files"), -- Toggle the files panel.
    },
    file_panel = {
      ["j"] = action("next_entry"), -- Bring the cursor to the next file entry
      ["<down>"] = action("next_entry"),
      ["k"] = action("prev_entry"), -- Bring the cursor to the previous file entry.
      ["<up>"] = action("prev_entry"),
      ["<cr>"] = action("select_entry"), -- Open the diff for the selected entry.
      ["o"] = action("select_entry"),
      ["R"] = action("refresh_files"), -- Update stats and entries in the file list.
      ["<tab>"] = action("select_next_entry"),
      ["<s-tab>"] = action("select_prev_entry"),
      ["<leader>e"] = action("focus_files"),
      ["<leader>b"] = action("toggle_files"),
    },
  },
})
