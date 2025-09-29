return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "moll/vim-bbye",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("bufferline").setup {
      options = {
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        left_mouse_command = "buffer %d",
        buffer_close_icon = "󰅖",
        close_icon = "",
        path_components = 1,
        modified_icon = "●",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        tab_size = 20,
        diagnostics = false,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        separator_style = { "│", "│" },
        enforce_regular_tabs = true,
        always_show_bufferline = false, -- Hide when only one buffer
        show_tab_indicators = false,
        indicator = { style = "none" },
        minimum_padding = 1,
        maximum_padding = 5,
        sort_by = "insert_at_end",
        -- Offset for nvim-tree
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
      },
      highlights = {
        fill = { bg = "#1F1F28" },
        background = { bg = "#1F1F28", fg = "#7C818C" },
        separator = { fg = "#434C5E", bg = "#1F1F28" },
        buffer_selected = {
          bg = "#1F1F28",
          bold = true,
          italic = false,
        },
        close_button = { bg = "#1F1F28" },
        close_button_selected = { bg = "#1F1F28" },
        tab_selected = { bg = "#1F1F28" },
        indicator_selected = { bg = "#1F1F28" },
        offset_separator = { fg = "#434C5E", bg = "#1F1F28" },
        modified = { bg = "#1F1F28" },
      },
    }
  end,
}
