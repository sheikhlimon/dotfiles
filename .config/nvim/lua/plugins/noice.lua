return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local width = math.floor(vim.o.columns * 0.5)
    local height = math.floor(vim.o.lines * 0.3)
    local sig_height = math.floor(vim.o.lines * 0.2)

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
          view = nil,
          opts = {
            border = { style = "rounded" },
            size = {
              max_width = width,
              max_height = height,
            },
            win_options = {
              wrap = true,
              linebreak = true,
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
          view = nil,
          opts = {
            border = { style = "rounded" },
            size = {
              max_width = width,
              max_height = sig_height,
            },
          },
        },
      },
      messages = {
        enabled = true,
        view = "mini",
        view_error = "mini",
        view_warn = "mini",
      },
      views = {
        mini = {
          win_options = {
            winblend = 10,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
      presets = {
        bottom_search = true, -- classic bottom search bar
        command_palette = true, -- position cmdline + popup together
        long_message_to_split = true, -- split view for long messages
        inc_rename = false, -- enable input dialog for inc-rename.nvim
        lsp_doc_border = true, -- borders on hover/signature
      },
    }
  end,
}

-- return {
--   "folke/noice.nvim",
--   event = "VeryLazy",
--   enabled = true,
--   opts = {},
--   dependencies = {
--     "MunifTanjim/nui.nvim",
--   },
--   config = function()
--     require("noice").setup {
--       lsp = {
--         override = {
--           ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--           ["vim.lsp.util.stylize_markdown"] = true,
--           ["cmp.entry.get_documentation"] = true,
--         },
--         hover = {
--           enabled = true,
--           silent = true,
--           view = nil, -- when nil, use defaults from documentation
--           opts = {
--             -- Configure hover window size here
--             border = {
--               style = "rounded",
--             },
--             position = {
--               row = 2,
--               col = 2,
--             },
--             size = {
--               max_width = 50, -- This controls the width!
--               max_height = 10, -- This controls the height!
--             },
--             win_options = {
--               wrap = true,
--             },
--           },
--         },
--         signature = {
--           enabled = true,
--           auto_open = {
--             enabled = true,
--             trigger = true,
--             luasnip = true,
--             throttle = 50,
--           },
--           view = nil, -- when nil, use defaults from documentation
--           opts = {
--             size = {
--               max_width = 50,
--               max_height = 10,
--             },
--           },
--         },
--       },
--       presets = {
--         bottom_search = true, -- use a classic bottom cmdline for search
--         command_palette = true, -- position the cmdline and popupmenu together
--         long_message_to_split = true, -- long messages will be sent to a split
--         inc_rename = false, -- enables an input dialog for inc-rename.nvim
--         lsp_doc_border = true, -- add a border to hover docs and signature help
--       },
--     }
--   end,
-- }
