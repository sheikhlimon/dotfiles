return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require "luasnip"

      luasnip.setup {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      }

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Load custom snippets
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = { vim.fn.stdpath "config" .. "/snippets" },
      }
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            min_keyword_length = 2,
            score_offset = 95,
          },
        },
      },

      cmdline = {
        keymap = { preset = "super-tab" },
        completion = { menu = { auto_show = true } },
      },

      completion = {
        list = { selection = { auto_insert = true } },
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          draw = {
            gap = 2,
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 2 },
            },
          },
        },
        ghost_text = { enabled = false },
      },
    },
  },

  -- noice for handling documentation and signature UI
  {
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
        -- messages = {
        --   enabled = true,
        --   view = "mini",
        --   view_error = "mini",
        --   view_warn = "mini",
        -- },
        -- views = {
        --   mini = {
        --     win_options = {
        --       winblend = 10,
        --       winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        --     },
        --   },
        -- },
        presets = {
          bottom_search = true, -- classic bottom search bar
          command_palette = true, -- position cmdline + popup together
          long_message_to_split = true, -- split view for long messages
          inc_rename = false, -- enable input dialog for inc-rename.nvim
          lsp_doc_border = true, -- borders on hover/signature
        },
      }
    end,
  },
}
