return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk Diff" },
    { "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line Popup" },
    { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },
    { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
    { "<leader>tb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Line Blame" },
    { "]c", function() require("gitsigns").next_hunk() end, desc = "Next Git Hunk" },
    { "[c", function() require("gitsigns").prev_hunk() end, desc = "Previous Git Hunk" },
  },
  opts = {
    signs = {
      add = { text = "┃" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "" },
    },
    signs_staged = {
      add = { text = "┃" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "" },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      delay = 350,
      virt_text_pos = "eol",
    },
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },
}
