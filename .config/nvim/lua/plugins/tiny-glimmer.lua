return {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  opts = {
    enabled = true,
    disable_warnings = true,
    refresh_interval_ms = 8,
    overwrite = {
      yank = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "#f6c177",
            max_duration = 300,
            min_duration = 200,
          },
        },
      },
      undo = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "#eb6f92",
            max_duration = 300,
            min_duration = 200,
          },
        },
        undo_mapping = "u",
      },
      redo = {
        enabled = true,
        default_animation = {
          name = "reverse_fade",
          settings = {
            from_color = "#9ccfd8",
            max_duration = 300,
            min_duration = 200,
          },
        },
        redo_mapping = "<C-r>",
      },
      paste = {
        enabled = true,
        default_animation = {
          name = "reverse_fade",
          settings = {
            from_color = "#c4a7e7",
            max_duration = 300,
            min_duration = 200,
          },
        },
        paste_mapping = "p",
        paste_in_place_mapping = "P",
      },
    },
  },
  config = function(_, opts)
    require("tiny-glimmer").setup(opts)
  end,
}
