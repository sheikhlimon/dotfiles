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
        -- Custom filter to hide bufferline when inappropriate
        custom_filter = function(buf_number, buf_numbers)
          -- Hide if no real files are open (only unnamed buffers)
          local buf_name = vim.api.nvim_buf_get_name(buf_number)
          if buf_name == "" then
            return false
          end

          -- Count real file buffers (not unnamed, help, etc.)
          local real_buffers = 0
          for _, buf in ipairs(buf_numbers) do
            local name = vim.api.nvim_buf_get_name(buf)
            local buftype = vim.bo[buf].buftype -- <-- changed here
            if name ~= "" and buftype == "" then
              real_buffers = real_buffers + 1
            end
          end

          -- Only show if we have more than one real buffer
          return real_buffers > 1
        end,
      },
      highlights = {
        fill = { bg = "#1F1F28" },
        background = { bg = "#1F1F28" },
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
      },
    }
  end,
}
