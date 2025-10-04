return {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  opts = {
    enabled = true,
    disable_warnings = true,
    refresh_interval_ms = 8,
    overwrite = {
      undo = {
        enabled = true,
        keymaps = { "u" },
        animation_type = "highlight",
        animation_settings = { from_color = "DiffDelete", duration = 200 },
      },
      redo = {
        enabled = true,
        keymaps = { "<C-r>" },
        animation_type = "highlight",
        animation_settings = { from_color = "DiffAdd", duration = 200 },
      },
      yank = {
        enabled = true,
        keymaps = { "y", "Y" },
        animation_type = "highlight",
        animation_settings = { from_color = "Visual", duration = 300 },
      },
      paste = {
        enabled = true,
        keymaps = { "p", "P" },
        animation_type = "highlight",
        animation_settings = { from_color = "IncSearch", duration = 150 },
      },
    },
  },
  config = function(_, opts)
    require("tiny-glimmer").setup(opts)
  end,
}
