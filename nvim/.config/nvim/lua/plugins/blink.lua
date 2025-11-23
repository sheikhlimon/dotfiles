return {
  -- LuaSnip with friendly-snippets and custom snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local luasnip = require "luasnip"
      luasnip.setup {
        history = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      }
      -- Load both friendly-snippets and custom snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = { vim.fn.stdpath "config" .. "/snippets" },
      }
    end,
  },
  -- Blink.cmp
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*",
    dependencies = { "L3MON4D3/LuaSnip" },
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
                -- Filter out single-char items, brackets, and snippet kind (15)
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
            score_offset = 95, -- High priority for snippets
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
            auto_show = function()
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
        enabled = false, -- Noice handles signature help
      },
    },
  },
}
