return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    { "<leader>e", "<cmd>Yazi<CR>", desc = "Open Yazi at current file" },
    { "<C-n>", "<cmd>Yazi cwd<CR>", desc = "Open Yazi in cwd" },
  },

  opts = {
    open_for_directories = false,
    floating_window_scaling_factor = 1.0,
    border = "rounded",
    use_nerdfont = true,
    start_in_insert = false,
  },
}
