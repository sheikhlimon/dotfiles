return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>e",
      "<cmd>Yazi<cr>",
      desc = "Open file manager",
    },
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open file manager in cwd",
    },
  },
  opts = {
    -- Replace netrw with yazi
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
    yazi_floating_window_border = "rounded",
  },
}
