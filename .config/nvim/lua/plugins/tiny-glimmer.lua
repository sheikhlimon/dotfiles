local function get_theme_palette()
  local is_light = vim.o.background == "light"
  return {
    bg = is_light and "#FFFCF0" or "#100F0F",
    yank = "#f6c177", -- gold
    undo = "#eb6f92", -- red
    redo = "#9ccfd8", -- cyan
    paste = "#c4a7e7", -- purple
  }
end

return {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  opts = function()
    local p = get_theme_palette()
    return {
      enabled = true,
      disable_warnings = true,
      refresh_interval_ms = 8,
      transparency_color = p.bg,
      overwrite = {
        yank = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = p.yank,
              to_color = p.bg,
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
              from_color = p.undo,
              to_color = p.bg,
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
              from_color = p.redo,
              to_color = p.bg,
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
              from_color = p.paste,
              to_color = p.bg,
              max_duration = 300,
              min_duration = 200,
            },
          },
          paste_mapping = "p",
          paste_in_place_mapping = "P",
        },
      },
    }
  end,
  config = function(_, opts)
    require("tiny-glimmer").setup(opts)
  end,
}
