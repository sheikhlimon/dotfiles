return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = "rafamadriz/friendly-snippets",
  version = "1.*",
  config = function()
    -- Remove conflicting default mappings FIRST
    pcall(vim.keymap.del, "i", "<Tab>")
    pcall(vim.keymap.del, "s", "<Tab>")
    pcall(vim.keymap.del, "i", "<S-Tab>")
    pcall(vim.keymap.del, "s", "<S-Tab>")

    -- THEN setup blink.cmp with simple enhancements
    require("blink-cmp").setup {
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
        list = { selection = { auto_insert = true } }, -- inserts potential selection when scrolling through list
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
          },
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
        ghost_text = {
          enabled = true,
        },
      },
    }
  end,
}
