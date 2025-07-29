return {
  "akinsho/toggleterm.nvim",
  version = "*",

  opts = {
    start_in_insert = true,
    direction = "float",
    float_opts = {
      border = "curved",
    },
    autochdir = true,
    highlights = {
      NormalFloat = { link = "NormalSB" },
      FloatBorder = { link = "FloatBorder" },
    },
  },

  keys = {
    { "<M-i>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle terminal with Alt+i" },
    { "<Esc>", "<cmd>ToggleTerm<CR>", mode = "t", desc = "Close terminal with Esc" },
  },
}
