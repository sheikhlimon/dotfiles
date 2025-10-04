return {
  -- LuaSnip with friendly-snippets and custom snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    lazy = true,
    event = "InsertEnter", -- load only when entering insert mode
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local luasnip = require "luasnip"

      luasnip.setup {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      }

      -- Load friendly and custom snippets
      require("luasnip.loaders.from_vscode").lazy_load {
        include = { "javascript", "javascriptreact", "typescript", "typescriptreact", "python", "json" },
        paths = { vim.fn.stdpath "config" .. "/snippets" },
      }
    end,
  },

  -- Blink.cmp
  {
    "saghen/blink.cmp",
    lazy = true,
    event = "InsertEnter",
    version = "*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      -- "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "super-tab",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-y>"] = { "accept" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            -- Filter out snippet-like completions from LSP
            transform_items = function(_, items)
              local filtered_items = {}
              for _, item in ipairs(items) do
                -- Filter out single character completions and common unwanted items
                if
                  item.label
                  and string.len(item.label) > 1 -- Filter single characters
                  and not item.label:match "^[(){}%[%]]$" -- Filter brackets
                  and item.kind ~= 15
                then -- Filter snippet kind (15 = snippet)
                  table.insert(filtered_items, item)
                end
              end
              return filtered_items
            end,
          },
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
          auto_show = false,
        },
        menu = {
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
            gap = 1,
            -- columns = {
            -- { "label", "label_description", gap = 1 },
            -- { "kind_icon", "kind", gap = 2 },
            -- },
          },
        },
        ghost_text = { enabled = false },
      },
    },
  },

  -- Noice: search and cmd positioning, documentation and signature UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      local width = math.floor(vim.o.columns * 0.35)
      local height = math.floor(vim.o.lines * 0.3)
      local sig_height = math.floor(vim.o.lines * 0.20)

      require("noice").setup {
        notify = {
          enabled = false, -- don't override vim.notify
        },
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
                winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
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
              win_options = {
                wrap = true,
                linebreak = true,
                winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
              },
            },
          },
        },
        cmdline = {
          view = "cmdline",
        },
        presets = {
          bottom_search = true,
          command_palette = false,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      }
    end,
  },
}
