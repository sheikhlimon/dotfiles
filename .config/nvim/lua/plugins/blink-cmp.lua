return {
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    config = function()
      require("luasnip").setup {}
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("blink.cmp").setup {
        snippets = { preset = "luasnip" },
        signature = { enabled = false },
        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "normal",
        },
        sources = {
          default = { "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
            cmdline = {
              min_keyword_length = 2,
            },
          },
        },
        keymap = {
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
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
      }
    end,
  },
}

-- return {
--   "saghen/blink.cmp",
--   event = { "InsertEnter", "CmdlineEnter" },
--   dependencies = "rafamadriz/friendly-snippets",
--   version = "1.*",
--   config = function()
--     -- Remove conflicting default mappings FIRST
--     pcall(vim.keymap.del, "i", "<Tab>")
--     pcall(vim.keymap.del, "s", "<Tab>")
--     pcall(vim.keymap.del, "i", "<S-Tab>")
--     pcall(vim.keymap.del, "s", "<S-Tab>")
--
--     -- THEN setup blink.cmp with simple enhancements
--     require("blink-cmp").setup {
--       keymap = {
--         ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
--         ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
--         ["<CR>"] = { "accept", "fallback" },
--         ["<C-e>"] = { "hide", "fallback" },
--       },
--       cmdline = {
--         keymap = { preset = "super-tab" },
--         completion = { menu = { auto_show = true } },
--       },
--       completion = {
--         list = { selection = { auto_insert = true } }, -- inserts potential selection when scrolling through list
--         documentation = {
--           auto_show = true,
--           window = {
--             border = "rounded",
--           },
--         },
--         menu = {
--           border = "rounded",
--           draw = {
--             gap = 2,
--             columns = {
--               { "label", "label_description", gap = 1 },
--               { "kind_icon", "kind", gap = 2 },
--             },
--           },
--         },
--         ghost_text = {
--           enabled = true,
--         },
--       },
--     }
--   end,
-- }
