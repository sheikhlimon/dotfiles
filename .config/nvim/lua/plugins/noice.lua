return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("noice").setup {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = true,
          view = nil, -- when nil, use defaults from documentation
          opts = {
            -- Configure hover window size here
            border = {
              style = "rounded",
            },
            -- position = {
            --   row = 2,
            --   col = 2,
            -- },
            size = {
              max_width = 50, -- This controls the width!
              max_height = 10, -- This controls the height!
            },
            win_options = {
              wrap = true,
            },
          },
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
          view = nil, -- when nil, use defaults from documentation
          opts = {
            size = {
              max_width = 50,
              max_height = 10,
            },
          },
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    }
  end,
}
