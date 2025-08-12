return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { hl = "GitGutterAdd", text = "+" },
      change = { hl = "GitGutterChange", text = "~" },
      delete = { hl = "GitGutterDelete", text = "_" },
      topdelete = { hl = "GitGutterDelete", text = "‾" },
      changedelete = { hl = "GitGutterChange", text = "~" },
    },
    signs_staged = {
      add = { hl = "GitGutterAdd", text = "+" },
      change = { hl = "GitGutterChange", text = "~" },
      delete = { hl = "GitGutterDelete", text = "_" },
      topdelete = { hl = "GitGutterDelete", text = "‾" },
      changedelete = { hl = "GitGutterChange", text = "~" },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      delay = 0,
      virt_text_pos = "eol",
    },
    -- Optional: toggle signs, etc.
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
  },
}
