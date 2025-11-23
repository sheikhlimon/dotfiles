return {
  -- Noice: enhanced UI for LSP and messages
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("noice").setup {
      notify = {
        enabled = false, -- Snacks.nvim handles notifications
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = true,
          opts = {
            size = {
              max_width = math.floor(vim.o.columns * 0.5),
              max_height = math.floor(vim.o.lines * 0.3),
            },
            win_options = {
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
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
          opts = {
            size = {
              max_width = math.floor(vim.o.columns * 0.4),
              max_height = math.floor(vim.o.lines * 0.2),
            },
            win_options = {
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
              wrap = true,
              linebreak = true,
            },
          },
        },
        progress = {
          enabled = true,
          throttle = 1000 / 30,
          view = "mini",
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
      },
      cmdline = {
        enabled = true,
        view = "cmdline", -- Keeps cmdline at bottom instead of popup
      },
      popupmenu = {
        enabled = false, -- Blink.cmp handles completion
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        lsp_doc_border = true, -- Uses vim.o.winborder
      },
      routes = {
        -- Skip common noisy messages
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "No information available" },
              { find = "written" },
            },
          },
          opts = { skip = true },
        },
        -- Skip recording messages and mode changes
        {
          filter = {
            event = "msg_showmode",
          },
          opts = { skip = true },
        },
      },
      views = {
        mini = {
          backend = "mini",
          relative = "editor",
          align = "message-right",
          timeout = 2000,
          reverse = true,
          position = {
            row = -2,
            col = "100%",
          },
          border = { style = "none" },
          zindex = 60,
          win_options = {
            winblend = 0,
            winhighlight = { Normal = "NoiceMini" },
          },
        },
        hover = {
          border = {
            style = "single",
          },
          position = { row = 2, col = 2 },
          win_options = {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
    }
  end,
}
