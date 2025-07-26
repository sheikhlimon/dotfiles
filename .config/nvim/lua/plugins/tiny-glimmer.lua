return {
  "rachartier/tiny-glimmer.nvim",
  keys = { "u", "<c-r>" },
  opts = {
    overwrite = {
      redo = {
        enabled = true,
        default_animation = {
          settings = {
            from_color = "DiffAdd",
          },
        },
      },

      undo = {
        enabled = true,
        default_animation = {
          settings = {
            from_color = "DiffDelete",
          },
        },
      },
    },
  },
}
