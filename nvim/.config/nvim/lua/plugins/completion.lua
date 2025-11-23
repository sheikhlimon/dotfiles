return {
  -- LuaSnip with friendly-snippets and custom snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    lazy = true,
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local luasnip = require "luasnip"

      luasnip.setup {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      }

      -- Load friendly-snippets first
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Then load custom snippets
      require("luasnip.loaders.from_vscode").lazy_load {
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
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            transform_items = function(_, items)
              local filtered_items = {}
              for _, item in ipairs(items) do
                if
                  item.label
                  and string.len(item.label) > 1
                  and not item.label:match "^[(){}%[%]]$"
                  and item.kind ~= 15
                then
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
        enabled = true,
        keymap = {
          preset = "cmdline",
        },
        completion = {
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ":"
            end,
            border = "single",
            draw = {
              columns = { { "label" } },
            },
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection",
          },
        },
      },
      
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
        
        menu = {
          border = "single",
          draw = {
            treesitter = { "lsp" },
            columns = { 
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection",
          direction_priority = { "s", "n" },
        },
        
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "single",
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
        
        ghost_text = {
          enabled = true,
        },
      },
      
      signature = {
        enabled = false, -- Let Noice handle signature help
      },
    },
  },

  -- Noice: enhanced UI for LSP and messages
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("noice").setup {
        -- Disable notify - snacks.nvim handles this
        notify = {
          enabled = false,
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
            view = "hover",
            opts = {
              border = "single",
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
            view = "hover",
            opts = {
              border = "single",
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
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30,
            view = "mini",
          },
          
          message = {
            enabled = true,
            view = "notify",
          },
        },

        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },

        cmdline = {
          enabled = true, -- Enable Noice cmdline since cmdheight=0
          view = "cmdline",
        },

        popupmenu = {
          enabled = false, -- Blink handles completion
        },

        presets = {
          bottom_search = true,
          command_palette = false,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },

        routes = {
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
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
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
            size = "auto",
            border = {
              style = "none",
            },
            zindex = 60,
            win_options = {
              winblend = 0,
              winhighlight = {
                Normal = "NoiceMini",
                IncSearch = "",
                CurSearch = "",
                Search = "",
              },
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

        health = {
          checker = false,
        },
      }
    end,
  },
}
