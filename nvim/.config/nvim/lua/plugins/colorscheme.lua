return {
  {
    "savq/melange-nvim",
    priority = 1000,
    config = function()
      -- Load melange colorscheme
      vim.cmd "colorscheme melange"

      -- Disable italics for main groups but keep their colors
      local italic_off_groups = {
        -- Standard syntax groups
        "Comment",
        "String",
        "Keyword",
        "Function",
        "Type",
        "Constant",
        "Identifier",

        -- Treesitter groups
        "@comment",
        "@string",
        "@keyword",
        "@function",
        "@type",
        "@constant",
        "@identifier",
        "@field",
        "@property",
        "@variable",
        "@variable.builtin",
        "@parameter",
        "@attribute",

        -- LSP semantic tokens (some themes apply italics here)
        "@lsp.typemod.variable.readonly",
        "@lsp.typemod.variable.defaultLibrary",
        "@lsp.typemod.variable.global",
      }

      for _, group in ipairs(italic_off_groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok and hl then
          local opts = {}
          if hl.fg then
            opts.fg = hl.fg
          end
          if hl.bg then
            opts.bg = hl.bg
          end
          opts.italic = false
          vim.api.nvim_set_hl(0, group, opts)
        end
      end

      -- Set custom background color
      vim.api.nvim_set_hl(0, "Normal", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1F1F28" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1F1F28", fg = "#444444" }) -- you can tweak fg
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1F1F28" }) -- completion menu
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2a2a2a" }) -- selected item
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = "#1F1F28", fg = "#444444" }) -- window split line
    end,
  },
}
